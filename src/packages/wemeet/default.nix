{ config, nixpak, pkgs, ... }:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, lib, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.wemeet;
        app.binPath = "bin/wemeet-xwayland";

        gpu.provider = lib.mkForce "nixos";

        dbus.policies = {
          "org.fcitx.Fcitx" = "talk";       # fcitx4 name: wemeet's bundled Qt platform plugin (libfcitxplatforminputcontextplugin.so) talks to this, not Fcitx5
          "org.fcitx.Fcitx5" = "talk";      # fcitx5 name
          "org.freedesktop.IBus" = "talk";  # wemeet also ships an IBus plugin + IBUS_USE_PORTAL=1
        };

        bubblewrap = {
          shareIpc = true;
          sockets.x11 = true;

          bind.ro = [
            "/etc"
          ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
          ];

          env = {
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
          };
        };
      };
  };
in
{
  my.packages.wemeet = app.config.env;
  home.packages = [ config.my.packages.wemeet ];
}