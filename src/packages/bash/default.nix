{ pkgs, config, ... }: {
  my.packages.bash = config.programs.bash.package;

  programs.bash.enable = true;
  programs.bash.initExtra = ''
    PROMPT_COMMAND=("history -a" "''${PROMPT_COMMAND[@]}")
  '';

  home.packages = [
    (pkgs.writeShellApplication {
      name = "my-bash-escape-std";
      text = ''
        input=$(cat)
        printf "%s" "''${input@Q}"
      '';
    })
  ];
}
