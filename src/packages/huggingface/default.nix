{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    python314Packages.huggingface-hub
  ];
}
