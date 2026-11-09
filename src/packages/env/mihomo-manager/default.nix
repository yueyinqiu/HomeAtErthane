{ nixpkgs-master, ... }: {
  home-manager-mihomo-manager.enable = true;
  home-manager-mihomo-manager.packages.mihomo-tui = nixpkgs-master.mihomo-tui;
}
