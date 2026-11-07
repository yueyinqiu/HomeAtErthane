{
  config,
  nixpak,
  pkgs,
  ...
}:
let
  mpv = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.mpv;
        app.binPath = "bin/mpv";
        app.extraEntrypoints = [
          "/bin/umpv"
          "/bin/mpv_identify.sh"
        ];

        bubblewrap = {
          dieWithParent = true;

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
        };
      };
  };
in
{
  my.packages.mpv = mpv.config.env;
  home.packages = [ config.my.packages.mpv ];
}
