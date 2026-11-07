{ ... }: {
  programs.snavi.cheats = {
    "vscode-code" = {
      src = ./cheats;
      entry = "code.json";
    };
    "vscode-open" = {
      src = ./cheats;
      entry = "open.json";
    };
  };
}
