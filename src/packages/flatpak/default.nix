{ pkgs, ... }: {
  home.packages = [
    pkgs.flatpak
  ];

  services.flatpak = {
    enable = false;
    remotes = {
      "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
    };
  };
}
