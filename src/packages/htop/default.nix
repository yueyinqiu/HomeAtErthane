{ pkgs, config, ... }: {
  my.packages.htop = pkgs.htop;

  home.packages = [
    config.my.packages.htop
  ];
}
