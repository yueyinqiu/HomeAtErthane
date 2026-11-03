{ pkgs, nixpak, ... }:
let
  mkNixPak = nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  wechat = mkNixPak {
    config =
      { sloth, lib, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.wechat;
        app.binPath = "bin/wechat";

        gpu.provider = lib.mkForce "nixos";

        dbus.policies = {
          "org.fcitx.Fcitx5" = "talk";
        };

        bubblewrap = {
          sockets = {
            x11 = true;
            wayland = lib.mkForce false;
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

          bind.ro = [
            "/etc/machine-id"
            "/sys"
            [
              (sloth.concat' sloth.homeDir "/.pki/nssdb")
              (sloth.concat' sloth.homeDir "/.pki/nssdb")
            ]
          ];

          env = {
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
