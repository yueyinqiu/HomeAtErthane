{ ... }: {
  programs.snavi.cheats = {
    "shuf-random-port" = {
      src = ./cheats;
      entry = "random-port.json";
    };
  };
}
