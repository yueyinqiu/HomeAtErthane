{ config, ... }: {
  my.packages.avizo = config.services.avizo.package;

  services.avizo.enable = true;
}
