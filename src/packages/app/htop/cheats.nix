{ ... }: {
  programs.snavi.cheats = {
    "htop-htop" = {
      src = ./cheats;
      entry = "htop.json";
    };
  };
}
