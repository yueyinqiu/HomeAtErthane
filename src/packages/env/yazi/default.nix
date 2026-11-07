{
  config,
  ...
}:
{
  my.packages.yazi = config.programs.yazi.package;

  programs.yazi.enable = true;
  programs.yazi.enableBashIntegration = true;
  xdg.configFile."yazi/theme.toml".source = ./theme.toml;
}
