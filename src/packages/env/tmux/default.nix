{ config, ... }: {
  my.packages.tmux = config.programs.tmux.package;

  programs.tmux = {
    enable = true;
    mouse = true;
    extraConfig = ''
      set -g extended-keys on
      set -g extended-keys-format csi-u
      set -g set-clipboard on
    '';
  };
}
