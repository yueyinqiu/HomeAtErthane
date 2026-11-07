{ ... }: {
  programs.snavi.cheats = {
    "steam-run-steam-run" = {
      src = ./cheats;
      entry = "steam-run.json";
    };
  };
}
