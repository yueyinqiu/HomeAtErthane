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
            (sloth.concat' sloth.homeDir "/.nix-profile")
            (sloth.concat' sloth.homeDir "/.local/state/nix/profiles")
          ];
        };
      };
  };
in
{
  my.packages.wechat = wechat.config.env;
  home.packages = [ config.my.packages.wechat ];
}