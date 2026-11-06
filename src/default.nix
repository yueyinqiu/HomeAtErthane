{ lib, ... }: {
  options.my = {
    packages = lib.mkOption {
      type = lib.types.attrsOf lib.types.package;
      default = { };
    };

    lib = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };

    paths = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
    };
  };

  config = {
    home.username = "yueyinqiu";
    home.homeDirectory = "/home/yueyinqiu";
    paths.s = "/home/yueyinqiu/s";

    nixpkgs.config.allowUnfree = true;

    home.stateVersion = "26.05";
  };
}
