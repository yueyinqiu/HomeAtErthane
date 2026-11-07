{ ... }: {
  programs.snavi.cheats = {
    "user-tun-control" = {
      src = ./cheats;
      entry = "control.json";
    };
  };
}