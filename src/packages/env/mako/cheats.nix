{ ... }: {
  programs.snavi.cheats = {
    "mako-history" = {
      src = ./cheats;
      entry = "history.json";
    };
  };
}
