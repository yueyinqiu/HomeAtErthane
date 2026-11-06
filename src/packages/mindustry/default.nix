{ config, nixpak, pkgs, mindustry-bin, ... }:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = mindustry-bin.mindustry-bin-160_7;
        app.binPath = "bin/mindustry";

        bubblewrap = {
          dieWithParent = true;

          sockets.pipewire = true;

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            config.my.paths.s
          ];

          bind.ro = [
            "/etc"
          ];

          env = {
            ALSA_CONFIG_PATH = "${pkgs.alsa-lib}/share/alsa/alsa.conf";
          };
        };
      };
  };
in
{
  my.packages.mindustry = app.config.env;
  home.packages = [ config.my.packages.mindustry ];
}