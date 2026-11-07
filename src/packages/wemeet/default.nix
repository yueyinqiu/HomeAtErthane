{ config, nixpak, pkgs, ... }:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.wemeet;
        app.binPath = "bin/wemeet-xwayland";

        dbus.policies = {
          "com.tencent.wemeet" = "own";
        };

        bubblewrap = {
          dieWithParent = true;

          bind.dev = [ "/dev" ];

          bind.ro = [
            "/etc"
          ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            config.my.paths.s
          ];

          env = {
            QT_IM_MODULE = "fcitx";
            EGL_PLATFORM = "x11";
          };
        };
      };
  };
in
{
  my.packages.wemeet = app.config.env;
  home.packages = [ config.my.packages.wemeet ];
}