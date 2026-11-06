{ pkgs, ... }:
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

  home.file.".pi/agent/sandbox.json".text = ''
    {
      "enabled": true,
      "network": {
        "disabled": true,
        "allowAllUnixSockets": true
      },
      "filesystem": {
        "allowRead": [
          ".",
          "~/.config",
          "~/.local",
          "~/.nix-profile"
        ]
      }
    }
  '';
}
