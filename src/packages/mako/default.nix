{ config, ... }: {
  my.packages.mako = config.services.mako.package;

  services.mako.enable = true;
}
