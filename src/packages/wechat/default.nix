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
            "/etc/passwd"
            "/etc/group"
            "/etc/os-release"
            "/etc/lsb-release"
            "/etc/localtime"
            "/etc/egl"
            "/sys"
            [
              (sloth.concat' sloth.homeDir "/.pki/nssdb")
              (sloth.concat' sloth.homeDir "/.pki/nssdb")
            ]
            [
              "${pkgs.bashInteractive}/bin/bash"
              "/bin/sh"
            ]
            [
              "${pkgs.bashInteractive}/bin/bash"
              "/bin/bash"
            ]
          ];

          env = {
            DISPLAY = sloth.env "DISPLAY";
            QT_QPA_PLATFORM = "xcb";
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
            XMODIFIERS = "@im=fcitx";

            LD_LIBRARY_PATH = sloth.concat [
              "/run/opengl-driver/lib:/run/opengl-driver-32/lib:"
              (sloth.envOr "LD_LIBRARY_PATH" "")
            ];

            PATH = sloth.concat [
              "${pkgs.coreutils}/bin:${pkgs.bashInteractive}/bin:${pkgs.findutils}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.procps}/bin:${pkgs.glibc.bin}/bin:"
              (sloth.envOr "PATH" "")
            ];
          };
        };
      };
  };
in
{
  home.packages = [ wechat.config.env ];
}