{ ... }: {
  programs.snavi.cheats = {
    "nb-disable-sync" = {
      src = ./cheats;
      entry = "disable-sync.json";
    };
    "nb-edit" = {
      src = ./cheats;
      entry = "edit.json";
    };
    "nb-set-remote" = {
      src = ./cheats;
      entry = "set-remote.json";
    };
    "nb-sync" = {
      src = ./cheats;
      entry = "sync.json";
    };
  };
}
