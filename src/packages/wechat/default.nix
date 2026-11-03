{ pkgs, nixpak, ... }:
let
  mkNixPak = nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  wechat = mkNixPak {
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
          sockets = {
            x11 = true;
            pulse = true;
          };

          tmpfs = [ "/tmp" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            (sloth.concat' sloth.homeDir "/Downloads")
          ];

          env = {
            WAYLAND_DISPLAY = null;
            DISPLAY = sloth.env "DISPLAY";
            QT_QPA_PLATFORM = "xcb";
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
            XMODIFIERS = "@im=fcitx";
          };
        };
      };
  };
in
{
  home.packages = [ wechat.config.env ];
}
