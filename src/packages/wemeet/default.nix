{ config, nixpak, pkgs, ... }:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, lib, pkgs, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.wemeet;
        app.binPath = "bin/wemeet-xwayland";

        gpu.provider = lib.mkForce "nixos";

        dbus.policies = {
          # 单实例：不 own 这个名，wemeet 会误判"已有实例"直接退出。
          "com.tencent.wemeet" = "own";
          # fcitx4 前端名 —— wemeet 自带的 Qt 插件只认这个，不认 Fcitx5。
          "org.fcitx.Fcitx" = "talk";
        };

        bubblewrap = {
          # 摄像头是 V4L2，编号会漂，干脆整个 /dev。--unshare-user 把 uid
          # 映射成本用户，因此只能碰本用户有权限的设备（video/input 等）。
          bind.dev = [ "/dev" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
          ];

          env = {
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