{ pkgs, config, ... }: {
  my.packages.fcitx5 = config.i18n.inputMethod.package;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
    ];
    fcitx5.settings.inputMethod = {
      GroupOrder."0" = "Default";
      "Groups/0" = {
        Name = "Default";
        "Default Layout" = "us";
        DefaultIM = "keyboard-us";
      };
      "Groups/0/Items/0".Name = "keyboard-us";
      "Groups/0/Items/1".Name = "pinyin";
    };
    fcitx5.settings.addons = {
      cloudpinyin = {
        globalSection = {
          Backend = "Baidu";
          MinimumPinyinLength = "2";
        };
      };
      pinyin = {
        globalSection = {
          CloudPinyinEnabled = true;
        };
      };
    };
    fcitx5.waylandFrontend = true;
  };
}
