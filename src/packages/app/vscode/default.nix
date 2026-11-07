{ config, pkgs, ... }: {
  my.packages.vscode = config.programs.vscode.package;

  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode;

  home.packages = [
    (pkgs.writeShellApplication {
      name = "c";
      text = ''
        exec ${config.my.packages.niri}/bin/niri msg action spawn -- ${config.my.packages.vscode}/bin/code "$PWD"
      '';
    })
  ];
}
