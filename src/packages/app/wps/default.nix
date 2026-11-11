{
  config,
  nixpak,
  pkgs,
  ...
}:
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
        app.extraEntrypoints = [
          "/bin/wpp"
          "/bin/et"
          "/bin/wpspdf"
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
            "/bin"
          ];

          env = {
            QT_IM_MODULE = "fcitx";
          };
        };
      };
  };
in
{
  my.packages.wps = wps.config.env;
  home.packages = [ config.my.packages.wps ];
}
