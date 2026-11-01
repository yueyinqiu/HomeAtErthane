{ config, pkgs, ... }:
{
  home-manager-mihomo-manager.instances.final = {
    port = 22764;
    configuration = ./config;
  };
}
