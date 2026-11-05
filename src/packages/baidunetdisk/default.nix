{ config, nixpak, baidunetdisk, ... }:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
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
          };
        };
      };
  };
in
{
  my.packages.baidunetdisk = app.config.env;
  home.packages = [ config.my.packages.baidunetdisk ];
}