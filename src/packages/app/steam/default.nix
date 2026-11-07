{ config, pkgs, nixpak, ... }:
let
  steam = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.steam;
        app.binPath = "bin/steam";

        dbus.policies = {
          "com.steampowered.*" = "own";
        };

        bubblewrap = {
          dieWithParent = true;

          shareIpc = true;

          tmpfs = [
            "/tmp"
          ];

          bind.dev = [ "/dev" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            config.my.paths.s
          ];

          bind.ro = [
            "/etc"
            "/run/opengl-driver-32"
          ];
        };
      };
  };
in
{
  my.packages.steam = steam.config.env;
  home.packages = [ config.my.packages.steam ];
}