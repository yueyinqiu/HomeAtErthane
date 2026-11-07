{ ... }: {
  programs.snavi.cheats = {
    "snavi-global" = {
      src = ./cheats;
      entry = "global.json";
    };
  };
}
