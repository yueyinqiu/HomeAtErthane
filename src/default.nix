{ lib, config, ... }: {
  options.my = {
    packages = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = { };
    };

    lib = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    s = lib.mkOption {
      type = lib.types.path;
    };
  };

  config = {
    home.username = "yueyinqiu";
    home.homeDirectory = "/home/yueyinqiu";
    my.s = "/home/yueyinqiu/s";

    nixpkgs.config.allowUnfree = true;

    home.stateVersion = "26.05";
  };
}