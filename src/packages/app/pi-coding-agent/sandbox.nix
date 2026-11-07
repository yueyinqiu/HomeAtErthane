{ pkgs, ... }:
let
  jsonFormat = pkgs.formats.json { };

  sandboxConfig = {
    enabled = true;
    network = {
      disabled = true;
      allowAllUnixSockets = true;
    };
    filesystem = {
      allowRead = [ ];
      # The whole launcher view writable. That view is already narrow: only
      # ~/s, ~/.pi/agent, /tmp and an ephemeral root tmpfs exist inside it, and
      # the read-only mounts (/nix, /etc, /usr, the nix profiles) survive
      # because bwrap binds non-recursively.
      allowWrite = [ "/" ];
      # The two deny lists protect different things and neither covers both:
      #   denyRead  -> bash, as an empty tmpfs (the tools ignore it unless a
      #                named sandbox profile is selected)
      #   denyWrite -> read/write/edit tools, in process. For bash it is dropped
      #                by an upstream bug: with allowWrite "/" the containment
      #                check compares against "//" and skips the mask. The
      #                tmpfs above is what actually stops bash.
      denyRead = [ "~/.pi/agent" ];
      denyWrite = [ "~/.pi/agent" ];
    };
  };
in
{
  programs.pi-coding-agent.settings.packages = [
    "npm:@xzzpig/pi-sandbox"
  ];

  programs.pi-coding-agent.extraPackages = [
    pkgs.nodejs_latest
    pkgs.bubblewrap
    pkgs.socat
    pkgs.ripgrep
  ];

  home.file.".pi/agent/sandbox.json".source = jsonFormat.generate "pi-sandbox.json" sandboxConfig;
}
