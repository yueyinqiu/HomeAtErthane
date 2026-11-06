{ config, nixpak, pkgs, ... }:
let
  qq = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        # 试：往 /.flatpak-info 的 [Context] 里声明 filesystems=host，
        # 看 xdg-desktop-portal 会不会因此认为 app 有直读权限、返回真实路径而不走 document portal。
        flatpak.info.Context.filesystems = "host";

        app.package = pkgs.qq;
        app.binPath = "bin/qq";

        dbus.policies = {
          "org.fcitx.Fcitx5" = "talk";
        };

        bubblewrap = {
          dieWithParent = true;

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
          ];

          bind.ro = [
            "/etc"
          ];

          env = {
            NIXOS_OZONE_WL = "1";
          };
        };
      };
  };
in
{
  my.packages.qq = qq.config.env;
  home.packages = [ config.my.packages.qq ];
}