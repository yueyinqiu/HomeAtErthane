{
  config,
  pkgs,
  lib,
  ...
}:
{
  my.packages.vscode = config.programs.vscode.package;

  programs.vscode.enable = true;
  programs.vscode.package = pkgs.vscode;

  home.packages = [
    (pkgs.writeShellApplication {
      name = "c";
      text = ''
        ${
          lib.escapeShellArgs [
            "exec"
            "${config.my.packages.niri}/bin/niri"
            "msg"
            "action"
            "spawn"
            "--"
            "${config.my.packages.vscode}/bin/code"
          ]
        } "$PWD"
      '';
    })
  ];
}
