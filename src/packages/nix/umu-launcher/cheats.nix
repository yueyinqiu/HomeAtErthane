{ ... }: {
  programs.snavi.cheats = {
    "umu-launcher-umu-run" = {
      src = ./cheats;
      entry = "umu-run.json";
    };
  };
}
