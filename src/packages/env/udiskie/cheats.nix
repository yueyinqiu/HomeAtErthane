{ ... }: {
  programs.snavi.cheats = {
    "udiskie-power-off" = {
      src = ./cheats;
      entry = "power-off.json";
    };
    "udiskie-unmount" = {
      src = ./cheats;
      entry = "unmount.json";
    };
  };
}
