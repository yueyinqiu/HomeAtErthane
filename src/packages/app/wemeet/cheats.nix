{ ... }: {
  programs.snavi.cheats = {
    "wemeet-wemeet" = {
      src = ./cheats;
      entry = "wemeet.json";
    };
  };
}
