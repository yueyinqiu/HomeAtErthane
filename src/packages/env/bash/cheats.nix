{ ... }: {
  programs.snavi.cheats = {
    "bash-bash" = {
      src = ./cheats;
      entry = "bash.json";
    };
  };
}
