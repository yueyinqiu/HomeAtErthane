{ pkgs, config, ... }: {
  my.packages.dotnet = pkgs.dotnetCorePackages.sdk_10_0;

  home.packages = [
    config.my.packages.dotnet
  ];
}
