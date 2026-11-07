{ ... }: {
  programs.snavi.cheats = {
    "avizo-brightness" = {
      src = ./cheats;
      entry = "brightness.json";
    };
    "avizo-microphone-toggle" = {
      src = ./cheats;
      entry = "microphone-toggle.json";
    };
    "avizo-speaker-toggle" = {
      src = ./cheats;
      entry = "speaker-toggle.json";
    };
    "avizo-speaker-volume" = {
      src = ./cheats;
      entry = "speaker-volume.json";
    };
  };
}
