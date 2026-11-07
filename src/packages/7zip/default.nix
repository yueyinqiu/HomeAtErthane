{ config, pkgs, ... }:
let
  sevenZip = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        app.package = pkgs._7zip-zstd;
        app.binPath = "bin/7z";
        app.extraEntrypoints = [
          "/bin/7za"
          "/bin/7zr"
          "/bin/7zz"
        ];

        dbus.enable = false;

        bubblewrap = {
          dieWithParent = true;

          network = false;

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