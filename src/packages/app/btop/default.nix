{ pkgs, config, ... }: {
  my.packages.btop = pkgs.btop;

  home.packages = [
    config.my.packages.btop
  ];
}
