{ config, nixpak, pkgs, ... }:
let
  firefox = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = pkgs.firefox;
        app.binPath = "bin/firefox";

        dbus.policies = {
          "org.fcitx.Fcitx5" = "talk";
          "org.mozilla.firefox.*" = "own";
        };

        bubblewrap = {
          dieWithParent = true;

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
          ];
        };
      };
  };
in
{
  my.packages.firefox = firefox.config.env;

  programs.firefox = {
    enable = true;
    package = config.my.packages.firefox;
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "f";
      text = ''
        exec niri msg action spawn -- firefox
      '';
    })
  ];
}