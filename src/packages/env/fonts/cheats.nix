{ ... }: {
  programs.snavi.cheats = {
    "fonts-find-family" = {
      src = ./cheats;
      entry = "find-family.json";
    };
  };
}
