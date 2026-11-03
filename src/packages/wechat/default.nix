{ pkgs, nixpak, ... }:
let
  mkNixPak = nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  wechat = mkNixPak {
    config =
      { sloth, ... }:
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
          ];

          env = {
            ELECTRON_OZONE_PLATFORM_HINT = "wayland";
            NIXOS_OZONE_WL = "1";
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";

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