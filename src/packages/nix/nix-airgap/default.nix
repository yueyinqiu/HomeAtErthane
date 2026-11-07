{
  nix-airgap,
  config,
  ...
}:
{
  my.packages.nix-airgap = nix-airgap.airgap;

  home.packages = [
    config.my.packages.nix-airgap
  ];
}
