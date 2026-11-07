{ ... }: {
  programs.snavi.cheats = {
    "fcitx5-diagnose" = {
      src = ./cheats;
      entry = "diagnose.json";
    };
  };
}
