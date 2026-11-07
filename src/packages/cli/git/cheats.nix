{ ... }: {
  programs.snavi.cheats = {
    "git-ac" = {
      src = ./cheats;
      entry = "ac.json";
    };
    "git-reset-soft" = {
      src = ./cheats;
      entry = "reset-soft.json";
    };
  };
}
