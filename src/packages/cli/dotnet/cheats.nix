{ ... }: {
  programs.snavi.cheats = {
    "dotnet-run-cs" = {
      src = ./cheats;
      entry = "run-cs.json";
    };
  };
}
