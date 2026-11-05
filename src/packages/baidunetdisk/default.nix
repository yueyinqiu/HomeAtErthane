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
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
            ELECTRON_OZONE_PLATFORM_HINT = "x11";
            # The host's GTK_PATH points through ~/.nix-profile -> /nix/var
            # symlinks that dangle in the sandbox (nixpak only binds
            # /nix/store).  Point GTK straight at fcitx5's immodules so it can
            # dlopen im-fcitx5.so.
            GTK_PATH = "${pkgs.fcitx5-gtk}/lib/gtk-3.0:${pkgs.fcitx5-gtk}/lib/gtk-4.0";
          };
        };
      };
  };
in
{
  my.packages.baidunetdisk = app.config.env;
  home.packages = [ config.my.packages.baidunetdisk ];
}