{ pkgs, config, ... }: {
  my.packages.trash-cli = pkgs.trash-cli;

  home.packages = [
    config.my.packages.trash-cli
  ];

}
