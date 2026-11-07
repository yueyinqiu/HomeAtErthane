{ ... }: {
  programs.snavi.cheats = {
    "firefox-niri-spawn" = {
      src = ./cheats;
      entry = "niri-spawn.json";
    };
  };
}
