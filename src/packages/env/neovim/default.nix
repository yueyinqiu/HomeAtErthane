{ config, ... }:
{
  my.packages.neovim = config.programs.neovim.package;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
}
