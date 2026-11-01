{ pkgs, ... }: {
  programs.firefox.enable = true;

  home.packages = [
    (pkgs.writeShellApplication {
      name = "f";
      text = ''
        exec niri msg action spawn -- firefox
      '';
    })
  ];
}
