{ ... }: {
  programs.snavi.cheats = {
    "expect-bash-run" = {
      src = ./cheats;
      entry = "bash-run.json";
    };
  };
}
