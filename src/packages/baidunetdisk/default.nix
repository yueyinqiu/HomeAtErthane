{ config, nixpak, baidunetdisk, ... }:
let
  app = config.my.lib.mkNixPak {
    config =
      { sloth, ... }:
      {
        imports = [
          nixpak.nixpakModules.gui-base
          nixpak.nixpakModules.network
        ];

        app.package = baidunetdisk.baidunetdisk;
        app.binPath = "bin/baidunetdisk";

        dbus.policies = {
          "org.fcitx.Fcitx5" = "talk";
        };

        bubblewrap = {
          sockets.x11 = true;

          bind.rw = [
            # Writable /tmp (also exposes /tmp/.X11-unix).  Must be a bind,
            # NOT a tmpfs: bwrap applies mounts in order, so a later
            # `--tmpfs /tmp` would wipe the X11 socket bound by sockets.x11.
            "/tmp"
            [
              (sloth.mkdir sloth.appDataDir)
              sloth.homeDir
            ]
            [
              sloth.homeDir
              (sloth.concat' sloth.homeDir "/home")
            ]
          ];

          env = {
            # Override TMPDIR leaked from `nix develop` (dev-switch); it used
            # to point into a build dir that doesn't exist in the sandbox.
            TMPDIR = "/tmp";
            ELECTRON_OZONE_PLATFORM_HINT = "x11";
            # fcitx on this host talks over XIM (XMODIFIERS=@im=fcitx), not the
            # GTK/Qt immodule.  DON'T set GTK_IM_MODULE: forcing "fcitx" makes
            # GTK look for a module that isn't loadable here and kills the XIM
            # fallback.
            XMODIFIERS = "@im=fcitx";
          };
        };
      };
  };
in
{
  my.packages.baidunetdisk = app.config.env;
  home.packages = [ config.my.packages.baidunetdisk ];
}