{ config, nixpak, baidunetdisk, ... }:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, pkgs, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = baidunetdisk.baidunetdisk;
        app.binPath = "bin/baidunetdisk";

        dbus.policies = {
          "org.fcitx.Fcitx5" = "talk";
        };

        bubblewrap = {
          sockets.x11 = true;

          # Make ~/.nix-profile (-> /nix/var/nix/profiles/...) resolvable so the
          # host's GTK_PATH symlink farm (with fcitx5's im-fcitx5.so + the
          # generated immodules.cache) actually resolves.  buildFHSEnv binds all
          # of /nix; nixpak only binds /nix/store, which dangles the profile
          # symlinks and is exactly why GTK never found the fcitx im-module.
          bind.ro = [
            "/nix/var/nix/profiles"
          ];

          bind.rw = [
            # Writable /tmp (also exposes /tmp/.X11-unix).  Must be a bind,
            # NOT a tmpfs: bwrap applies mounts in order, so a later
            # `--tmpfs /tmp` would wipe the X11 socket bound by sockets.x11.
            "/tmp"
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            [
              sloth.homeDir
              (sloth.concat' sloth.homeDir "/home")
            ]
          ];

          env = {
            # Override TMPDIR leaked from `nix develop` (dev-switch); it used
            # to point into a build dir that doesn't exist in the sandbox.
            TMPDIR = "/tmp";
            ELECTRON_OZONE_PLATFORM_HINT = "x11";
            # fcitx5's GTK im-module (im-fcitx5.so) registers as "fcitx".
            GTK_IM_MODULE = "fcitx";
            # Give GTK a self-contained immodules.cache that maps "fcitx" ->
            # im-fcitx5.so.  We can't rely on ~/.nix-profile/etc/gtk-3.0/… (the
            # profile symlink chain doesn't resolve in the sandbox), so bake the
            # entry directly, pointing at fcitx5-gtk's .so in the nix store
            # (reachable via bindEntireStore).
            GTK_IM_MODULE_FILE = "${pkgs.writeText "gtk-immodules.cache" ''
              "${pkgs.fcitx5-gtk}/lib/gtk-3.0/3.0.0/immodules/im-fcitx5.so"
              "fcitx" "Fcitx5 (Flexible Input Method Framework5)" "fcitx5" "${pkgs.fcitx5-gtk}/locale" "ja:ko:zh:*"
              "fcitx5" "Fcitx5 (Flexible Input Method Framework5)" "fcitx5" "${pkgs.fcitx5-gtk}/locale" "ja:ko:zh:*"
            ''}";
          };
        };
      };
  };
in
{
  my.packages.baidunetdisk = app.config.env;
  home.packages = [ config.my.packages.baidunetdisk ];
}