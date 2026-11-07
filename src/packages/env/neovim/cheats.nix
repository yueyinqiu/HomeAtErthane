{ ... }: {
  programs.snavi.cheats = {
    "nvim-edit" = {
      src = ./cheats;
      entry = "edit.json";
    };
  };
}