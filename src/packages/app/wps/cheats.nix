{ ... }: {
  programs.snavi.cheats = {
    "wps-wps" = {
      src = ./cheats;
      entry = "wps.json";
    };
  };
}
