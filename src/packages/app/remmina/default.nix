{
  config,
  pkgs,
  nixpak,
  ...
}:
let
  remmina = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.remmina;
        app.binPath = "bin/remmina";
        app.extraEntrypoints = [
          "/bin/remmina-file-wrapper"
        ];

        dbus.policies = {
          "org.remmina.Remmina" = "own";
        };

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
  my.packages.remmina = remmina.config.env;
  home.packages = [ config.my.packages.remmina ];
}
