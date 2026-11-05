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

          bind.ro = [
            (sloth.concat' sloth.homeDir "/.nix-profile")
            (sloth.concat' sloth.homeDir "/.local/state/nix/profiles")
          ];

          bind.dev = [
            "/tmp/.X11-unix"
          ];

          tmpfs = [
            "/tmp"
          ];

          bind.rw = [
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
            TMPDIR = "/tmp";
            # ELECTRON_OZONE_PLATFORM_HINT = "x11";
            # GTK_IM_MODULE = "fcitx";
            # GTK_IM_MODULE_FILE = sloth.concat' sloth.homeDir "/.nix-profile/etc/gtk-3.0/immodules.cache";
          };
        };
      };
  };
in
{
  my.packages.baidunetdisk = app.config.env;
  home.packages = [ config.my.packages.baidunetdisk ];
}