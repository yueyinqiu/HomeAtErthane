{ pkgs, config, ... }: {
  my.packages.expect = pkgs.expect;

  home.packages = [
    config.my.packages.expect

    (pkgs.writeShellApplication {
      name = "my-expect-bash-run";
      text = ''
        escaped="''${*@Q}"
        expect "${./bash-run.exp}" -- "$escaped"
      '';
    })
  ];
}
