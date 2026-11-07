{
  pkgs,
  config,
  ...
}:
{
  my.packages.steam-run = pkgs.steam-run;

  home.packages = [
    config.my.packages.steam-run
  ];
}
