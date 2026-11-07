{ ... }: {
  programs.snavi.cheats = {
    "ssh-add-list" = {
      src = ./cheats;
      entry = "list.json";
    };
  };
}