{ ... }: {
  programs.snavi.cheats = {
    "tmux-new" = {
      src = ./cheats;
      entry = "new.json";
    };
    "tmux-attach" = {
      src = ./cheats;
      entry = "attach.json";
    };
    "tmux-list" = {
      src = ./cheats;
      entry = "list.json";
    };
    "tmux-kill" = {
      src = ./cheats;
      entry = "kill.json";
    };
  };
}
