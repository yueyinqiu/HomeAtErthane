{ config, nixpak, pkgs, ... }:
let
  qq = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.qq;
        app.binPath = "bin/qq";

        dbus.policies = {
          "org.fcitx.Fcitx5" = "talk";
        };

        bubblewrap = {
          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
          ];

          bind.ro = [
            "/etc"
          ];

          env = {
            NIXOS_OZONE_WL = "1";
          };
        };
      };
  };
in
{
  my.packages.qq = qq.config.env;
  home.packages = [ config.my.packages.qq ];
}