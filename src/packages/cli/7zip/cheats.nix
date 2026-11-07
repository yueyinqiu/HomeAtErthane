{ ... }: {
  programs.snavi.cheats = {
    "7z-add" = {
      src = ./cheats;
      entry = "add.json";
    };
    "7z-extract" = {
      src = ./cheats;
      entry = "extract.json";
    };
    "7z-list" = {
      src = ./cheats;
      entry = "list.json";
    };
  };
}