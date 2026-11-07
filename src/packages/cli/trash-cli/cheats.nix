{ ... }: {
  programs.snavi.cheats = {
    "trash-cli-empty" = {
      src = ./cheats;
      entry = "empty.json";
    };
    "trash-cli-list" = {
      src = ./cheats;
      entry = "list.json";
    };
    "trash-cli-put" = {
      src = ./cheats;
      entry = "put.json";
    };
    "trash-cli-restore" = {
      src = ./cheats;
      entry = "restore.json";
    };
  };
}
