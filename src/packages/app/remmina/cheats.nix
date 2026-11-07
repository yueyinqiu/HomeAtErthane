{ ... }: {
  programs.snavi.cheats = {
    "remmina-remmina" = {
      src = ./cheats;
      entry = "remmina.json";
    };
  };
}
