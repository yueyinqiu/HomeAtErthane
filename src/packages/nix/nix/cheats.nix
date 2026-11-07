{ ... }: {
  programs.snavi.cheats = {
    "nix-shell" = {
      src = ./cheats;
      entry = "shell.json";
    };
  };
}
