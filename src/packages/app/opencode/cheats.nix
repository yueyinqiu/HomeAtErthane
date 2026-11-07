{ ... }: {
  programs.snavi.cheats = {
    "opencode-resume" = {
      src = ./cheats;
      entry = "resume.json";
    };
    "opencode-start" = {
      src = ./cheats;
      entry = "start.json";
    };
  };
}
