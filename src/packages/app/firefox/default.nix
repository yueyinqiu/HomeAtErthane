{ config, nixpak, pkgs, lib, ... }:
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
      text = lib.escapeShellArgs [
        "exec"
        "${config.my.packages.niri}/bin/niri"
        "msg"
        "action"
        "spawn"
        "--"
        "${config.my.packages.firefox}/bin/firefox"
      ];
    })
  ];
}