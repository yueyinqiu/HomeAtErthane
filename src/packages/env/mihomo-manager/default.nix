{ nixpkgs-master, ... }: {
  home-manager-mihomo-manager.enable = true;
  home-manager-mihomo-manager.mihomo-tui.package = nixpkgs-master.mihomo-tui;
}
