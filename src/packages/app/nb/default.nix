{ pkgs, config, ... }: {
  my.packages.nb = pkgs.nb;

  home.packages = [
    config.my.packages.nb
  ];
}
