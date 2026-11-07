{
  config,
  ...
}:
{
  my.packages.ssh-agent = config.services.ssh-agent.package;

  services.ssh-agent.enable = true;
}
