{ config, ... }: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # https://github.com/direnv/direnv/pull/1655
  programs.direnv.enableBashIntegration = false;
  programs.bash.initExtra = ''
    eval "$(${config.programs.direnv.package}/bin/direnv hook bash)"

    _direnv_hook() {
      local previous_exit_status=$?;
      local previous_sigint_trap="$(trap -p SIGINT)";
      trap -- "" SIGINT;
      vars="$(${config.programs.direnv.package}/bin/direnv export bash)";
      eval "$vars";
      eval "''${previous_sigint_trap:-trap - SIGINT}";
      return $previous_exit_status;
    }
  '';
}