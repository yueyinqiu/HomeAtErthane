{ ... }: {
  programs.snavi.cheats = {
    "niri-pick-window" = {
      src = ./cheats;
      entry = "pick-window.json";
    };
    "niri-spawn" = {
      src = ./cheats;
      entry = "spawn.json";
    };
  };
}
