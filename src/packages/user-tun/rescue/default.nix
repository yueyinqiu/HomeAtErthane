{ ... }:
{
  home-manager-mihomo-manager.instances.rescue = {
    port = 16884;
    configuration = ./config;
  };
}
