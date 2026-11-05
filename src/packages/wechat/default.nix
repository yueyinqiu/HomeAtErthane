{ config, nixpak, pkgs, ... }:
let
  wechat = config.my.lib.mkNixPak {
    config =
      { sloth, lib, ... }:
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
          dieWithParent = true;

          # 走 XWayland（对应 pre-nixpak wrapper 的 --unset WAYLAND_DISPLAY + QT_QPA_PLATFORM=xcb）
          sockets = {
            x11 = true;
            wayland = lib.mkForce false;
          };

          tmpfs = [ "/tmp" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
          ];

          bind.ro = [
            "/etc"
            "/sys"
          ];

          # 试：把宿主 /dev/shm 透进来，看能否救回 X11 Present 的 buffer 交换
          bind.dev = [ "/dev/shm" ];

          env = {
            DISPLAY = sloth.env "DISPLAY";
            QT_QPA_PLATFORM = "xcb";
            QT_IM_MODULE = "fcitx";
            XMODIFIERS = "@im=fcitx";
          };
        };
      };
  };
in
{
  my.packages.wechat = wechat.config.env;
  home.packages = [ config.my.packages.wechat ];
}