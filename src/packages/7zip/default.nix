{ pkgs, config, ... }: {
  my.packages."7zip" = pkgs._7zip-zstd;

  home.packages = [
    config.my.packages."7zip"
  ];
}
