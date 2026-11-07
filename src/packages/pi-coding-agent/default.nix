{ config, pkgs, ... }:
let
  home = config.home.homeDirectory;

  pi = config.my.lib.mkNixPak {
    config =
      { ... }:
      {
        app.package = pkgs.pi-coding-agent;
        app.binPath = "bin/pi";

        dbus.enable = false;

        bubblewrap = {
          dieWithParent = true;

          bind.rw = [
            "${home}/.pi/agent"
            config.my.paths.s
          ];

          bind.ro = [
            "/nix"
            "/usr"
            "/etc"
            "/bin"
            "/run/current-system"

            "${home}/.nix-profile"
            "${home}/.local/state/nix/profiles"

            "${home}/.config/git"
          ];

          bind.dev = [ "/dev/kvm" ];

          tmpfs = [ "/tmp" ];

          env = {
            PI_CLIPBOARD_OSC52 = "1";
          };
        };
      };
  };
in
{
  my.packages.pi-coding-agent = pi.config.env;

  programs.pi-coding-agent = {
    enable = true;
    package = config.my.packages.pi-coding-agent;
  };
}
