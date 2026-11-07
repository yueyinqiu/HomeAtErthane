{ ... }: {
  programs.snavi.cheats = {
    "steam-launch" = {
      src = ./cheats;
      entry = "launch.json";
    };
  };
}