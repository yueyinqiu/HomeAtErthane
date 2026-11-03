{ pkgs, nixpak, ... }:
let
  mkNixPak = nixpak.lib.nixpak {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  wechatNoSandbox = pkgs.symlinkJoin {
    name = "wechat-no-sandbox";
    paths = [ pkgs.wechat ];
    postBuild = ''
      mv "$out/bin/wechat" "$out/bin/.wechat-orig"
      cat > "$out/bin/wechat" <<'EOF'
#!/bin/sh
exec "$(dirname "$0")/.wechat-orig" --no-sandbox --disable-gpu-sandbox "$@"
EOF
      chmod +x "$out/bin/wechat"
    '';
  };

  wechat = mkNixPak {
    config =
      { sloth, lib, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = wechatNoSandbox;
        app.binPath = "bin/wechat";

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
            "/sys/devices/system/cpu"
            [
              (sloth.concat' sloth.homeDir "/.pki/nssdb")
              (sloth.concat' sloth.homeDir "/.pki/nssdb")
            ]
          ];

          env = {
            DISPLAY = sloth.env "DISPLAY";
            QT_QPA_PLATFORM = "xcb";
            GTK_IM_MODULE = "fcitx";
            QT_IM_MODULE = "fcitx";
            XMODIFIERS = "@im=fcitx";
          };
        };
      };
  };
in
{
  home.packages = [ wechat.config.env ];
}
