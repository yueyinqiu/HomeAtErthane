{ config, nixpak, pkgs, ... }:
let
  wechat = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.wechat;
        app.binPath = "bin/wechat";

        dbus.policies = {
          "org.fcitx.Fcitx5" = "talk";
        };

        bubblewrap = {
          dieWithParent = true;

          tmpfs = [ "/tmp" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
          ];

          bind.ro = [
            "/etc"
            "/sys"
          ];

          env = {
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
          };
        };
      };
  };
in
{
  my.packages.wechat = wechat.config.env;
  home.packages = [ config.my.packages.wechat ];
}