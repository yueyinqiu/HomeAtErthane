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
          "com.tencent.wemeet" = "own";      # single-instance D-Bus name: registerService fails without "own" -> app thinks a duplicate is running and quits
          "com.tencent.wemeet.*" = "own";
          "org.fcitx.Fcitx" = "talk";       # fcitx4 name: wemeet's bundled Qt platform plugin (libfcitxplatforminputcontextplugin.so) talks to this, not Fcitx5
          "org.fcitx.Fcitx5" = "talk";      # fcitx5 name
          "org.freedesktop.IBus" = "talk";  # wemeet also ships an IBus plugin + IBUS_USE_PORTAL=1
        };

        bubblewrap = {
          shareIpc = true;
          sockets.x11 = true;
          # Camera = V4L2 (/dev/video*).  wemeet opens /dev/video0 (+video1) via
          # its xcast lib; the sandbox must expose the device nodes.
          bind.dev = [
            "/dev/video0"
            "/dev/video1"
          ];

          # Strip --unshare-pid: with --share-net (shared network namespace),
          # the pidns PID (2, 3, ...) collides with the host's low-PID daemons'
          # netlink sockets, so Chromium's AddressTrackerLinux can't bind
          # NETLINK_ROUTE (EADDRINUSE) and wemeet aborts at startup.
          package = pkgs.writeShellScriptBin "bwrap" ''
            args=()
            for a in "$@"; do
              case "$a" in
                --unshare-pid) ;;
                *) args+=("$a") ;;
              esac
            done
            exec ${pkgs.bubblewrap}/bin/bwrap "''${args[@]}"
          '';

          bind.ro = [
            "/etc"
          ];

          bind.rw = [
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
          ];

          env = {
            GTK_IM_MODULE = "fcitx";
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