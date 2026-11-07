{ ... }: {
  programs.snavi.cheats = {
    "nh-search" = {
      src = ./cheats;
      entry = "search.json";
    };
  };
}
