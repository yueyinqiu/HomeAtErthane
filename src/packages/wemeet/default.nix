{ config, nixpak, pkgs, ... }:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.wemeet;
        app.binPath = "bin/wemeet-xwayland";

        dbus.policies = {
          "org.fcitx.Fcitx5" = "talk";
        };

        bubblewrap = {
          shareIpc = true;
          sockets.x11 = true;

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
          ];

          # env = {
          #   GTK_IM_MODULE = "fcitx";
          #   QT_IM_MODULE = "fcitx";
          # };
        };
      };
  };
in
{
  my.packages.wemeet = app.config.env;
  home.packages = [ config.my.packages.wemeet ];
}