{ config, pkgs, ... }:
{
  my.packages.ghostty = config.programs.ghostty.package;

  programs.ghostty.enable = true;
  programs.ghostty.settings = {
    shell-integration-features = "ssh-env";
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "g";
      text = ''
        exec ${config.my.packages.niri}/bin/niri msg action spawn -- ${config.my.packages.ghostty}/bin/ghostty --working-directory="$PWD"
      '';
    })
  ];
}
