{ pkgs, config, ... }:
let
  my-bash-escape-std = pkgs.writeShellApplication {
    name = "my-bash-escape-std";
    text = ''
      input=$(cat)
      printf "%s" "''${input@Q}"
    '';
  };
in
{
  my.packages.bash = config.programs.bash.package;
  my.packages.my-bash-escape-std = my-bash-escape-std;

  programs.bash.enable = true;
  programs.bash.initExtra = ''
    PROMPT_COMMAND=("history -a" "''${PROMPT_COMMAND[@]}")
  '';

  home.packages = [
    config.my.packages.my-bash-escape-std
  ];
}
