{
  config, 
  ...
}:
{
  xdg.configFile."nix/access-tokens.conf.example" = ''
    access-tokens = github.com=ghp_XXXXXX
  '';
  nix.extraOptions = ''
    !include ${config.xdg.configHome}/nix/access-tokens.conf
  '';
}
