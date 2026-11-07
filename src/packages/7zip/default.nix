{ config, pkgs, ... }:
let
  sevenZip = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        app.package = pkgs._7zip-zstd;
        app.binPath = "bin/7z";

        dbus.enable = false;

        bubblewrap = {
          dieWithParent = true;

          tmpfs = [ "/tmp" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            config.my.paths.s
          ];
        };
      };
  };
in
{
  my.packages."7z" = sevenZip.config.env;
  home.packages = [ config.my.packages."7z" ];
}