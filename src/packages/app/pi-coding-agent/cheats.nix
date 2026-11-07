{ ... }: {
  programs.snavi.cheats = {
    "pi-coding-agent-pi" = {
      src = ./cheats;
      entry = "pi.json";
    };
    "pi-coding-agent-resume" = {
      src = ./cheats;
      entry = "resume.json";
    };
  };
}
