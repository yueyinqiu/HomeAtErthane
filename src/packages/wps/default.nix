{ config, nixpak, pkgs, ... }:
let
  wps = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.wpsoffice-cn;
        app.binPath = "bin/wps";

        dbus.policies = {
          "org.fcitx.Fcitx5" = "talk";
        };

        bubblewrap = {
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

          bind.ro = [
            "/etc"
            "/bin"
          ];

          env = {
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
            SDL_IM_MODULE = "fcitx";
          };
        };
      };
  };
in
{
  my.packages.wps = wps.config.env;
  home.packages = [ config.my.packages.wps ];
}