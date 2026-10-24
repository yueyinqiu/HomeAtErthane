{ pkgs, ... }:
{
  home.packages = [
    pkgs.msedit
  ];

  home.sessionVariables = {
    EDITOR = "${pkgs.msedit}/bin/edit";
    VISUAL = "${pkgs.msedit}/bin/edit";
  };
}
