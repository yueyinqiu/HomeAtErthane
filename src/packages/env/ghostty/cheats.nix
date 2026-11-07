{ ... }: {
  programs.snavi.cheats = {
    "ghostty-ghostty" = {
      src = ./cheats;
      entry = "ghostty.json";
    };
  };
}
