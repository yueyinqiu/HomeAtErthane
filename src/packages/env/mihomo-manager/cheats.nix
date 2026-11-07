{ ... }: {
  programs.snavi.cheats = {
    "proxies-with" = {
      src = ./cheats;
      entry = "with.json";
    };
    "proxies-dashboard" = {
      src = ./cheats;
      entry = "dashboard.json";
    };
  };
}
