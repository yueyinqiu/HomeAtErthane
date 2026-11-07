{
  pkgs,
  config, 
  ...
}:
{
  my.packages.nix = pkgs.nix;

  nix.package = config.my.packages.nix;
  xdg.configFile."nix/access-tokens.conf.example".text = ''
    access-tokens = github.com=ghp_XXXXXX
  '';
  nix.extraOptions = ''
    !include ${config.xdg.configHome}/nix/access-tokens.conf
  '';
}
