{ config, pkgs, nixpak, ... }:
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

        dbus.policies = {
          # 密码存 gnome-keyring（libsecret → org.freedesktop.secrets）
          "org.freedesktop.secrets" = "talk";
          # GtkApplication 单实例：own 自己的 app id + status icon
          "org.remmina.Remmina" = "own";
          "org.remmina.Remmina.*" = "own";
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