{ config, pkgs, nixpak, ... }:
let
  steam = config.my.lib.mkNixPak {
    config =
      { sloth, lib, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.steam;
        app.binPath = "bin/steam";

        # steam 是 multiArch（32/64 位），要用宿主的 32 位 mesa 驱动，
        # 而不是 gui-base 默认 bundle 的纯 64 位 pkgs.mesa。
        gpu.provider = lib.mkForce "nixos";

        dbus.policies = {
          "com.steampowered.*" = "own";
        };

        bubblewrap = {
          dieWithParent = true;

          tmpfs = [
            "/tmp"
          ];

          bind.dev = [ "/dev" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            config.my.paths.s
          ];

          bind.ro = [
            "/etc"
            # 32 位 mesa 驱动（gui-base 的 gpu 只绑了 64 位 /run/opengl-driver）
            "/run/opengl-driver-32"
          ];
        };
      };
  };
in
{
  my.packages.steam = steam.config.env;
  home.packages = [ config.my.packages.steam ];
}