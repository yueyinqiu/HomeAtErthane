{ config, ... }: {
  my.packages.home-manager = config.programs.home-manager.package;

  programs.home-manager.enable = true;

}
