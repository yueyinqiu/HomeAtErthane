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

        # 用宿主 GL 驱动（跟宿主 XWayland 的 DRI3 匹配），而非 gui-base 默认的 bundled mesa
        gpu.provider = lib.mkForce "nixos";

        bubblewrap = {
          dieWithParent = true;

          # 共享宿主 IPC 命名空间：X11 的 Present/MIT-SHM 靠 SysV 共享内存把帧交给 XWayland，
          # --unshare-ipc 会把它隔离掉导致画面不更新（软渲染裸跑不卡的根因方向）。
          shareIpc = true;

          # 走 XWayland（对应 pre-nixpak wrapper 的 --unset WAYLAND_DISPLAY + QT_QPA_PLATFORM=xcb）
          sockets = {
            x11 = true;
            wayland = true;
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