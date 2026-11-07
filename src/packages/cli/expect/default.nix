{
  pkgs,
  config,
  lib,
  ...
}:
let
  my-expect-bash-run = pkgs.writeShellApplication {
    name = "my-expect-bash-run";
    text = ''
      escaped="''${*@Q}"
      ${
        lib.escapeShellArgs [
          "exec"
          "${config.my.packages.expect}/bin/expect"
          ./bash-run.exp
        ]
      } -- "$escaped"
    '';
  };
in
{
  my.packages.expect = pkgs.expect;
  my.packages.my-expect-bash-run = my-expect-bash-run;

  home.packages = [
    config.my.packages.expect
    config.my.packages.my-expect-bash-run
  ];
}
