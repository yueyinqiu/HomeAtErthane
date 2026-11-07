{ config, ... }: {
  my.packages.udiskie = config.services.udiskie.package;

  services.udiskie.enable = true;
  home.file."udiskie".source = config.lib.file.mkOutOfStoreSymlink "/run/media/yueyinqiu";

}
