{ lib, ... }: {
  options.my.packages = lib.mkOption {
    type = lib.types.attrsOf lib.types.package;
    default = { };
  };

  config = {
    home.username = "yueyinqiu";
    home.homeDirectory = "/home/yueyinqiu";

    nixpkgs.config.allowUnfree = true;

    home.stateVersion = "26.05";
  };
}