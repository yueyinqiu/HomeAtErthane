{ ... }: {
  programs.snavi.cheats = {
    "mpv-mpv" = {
      src = ./cheats;
      entry = "mpv.json";
    };
  };
}
