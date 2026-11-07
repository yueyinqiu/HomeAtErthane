{ pkgs, config, ... }: {
  my.packages.podman = config.services.podman.package;
  my.packages.podman-compose = pkgs.podman-compose;

  services.podman.enable = true;

  home.packages = [
    config.my.packages.podman-compose
  ];

}
