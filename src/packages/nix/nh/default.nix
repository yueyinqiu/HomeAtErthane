{ config, ... }: {
  my.packages.nh = config.programs.nh.package;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
  };
}
