{
  pkgs,
  config,
  ...
}:
{
  my.packages.huggingface = pkgs.python314Packages.huggingface-hub;

  home.packages = [
    config.my.packages.huggingface
  ];
}
