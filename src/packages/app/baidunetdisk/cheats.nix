{ ... }: {
  programs.snavi.cheats = {
    "baidunetdisk-launch" = {
      src = ./cheats;
      entry = "launch.json";
    };
  };
}