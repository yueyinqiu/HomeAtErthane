{ pkgs, config, ... }: {
  home-manager-mihomo-manager.enable = true;

  my.packages.mihomo-tui = pkgs.callPackage ./mihomo-tui { };
  home-manager-mihomo-manager.mihomo-tui.package = config.my.packages.mihomo-tui;
}
