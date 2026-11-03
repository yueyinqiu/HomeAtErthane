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
          "org.freedesktop.IBus" = "talk";
          "org.freedesktop.IBus.*" = "talk";
        };

        bubblewrap = {
          tmpfs = [ "/tmp" ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
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
              (sloth.concat' sloth.homeDir "/.config/fcitx5")
              (sloth.concat' sloth.homeDir "/.config/fcitx5")
            ]
            [
              (sloth.concat' sloth.homeDir "/.local/share/fcitx5/themes")
              (sloth.concat' sloth.homeDir "/.local/share/fcitx5/themes")
            ]
          ];

          env = {
            QT_QPA_PLATFORM = "wayland";
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
            NIXOS_OZONE_WL = "1";
            WAYLAND_DISPLAY = sloth.envOr "WAYLAND_DISPLAY" "wayland-0";

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