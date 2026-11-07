{ ... }: {
  programs.snavi.cheats = {
    "home-manager-generations" = {
      src = ./cheats;
      entry = "generations.json";
    };
  };
}
