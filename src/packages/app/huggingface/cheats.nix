{ ... }: {
  programs.snavi.cheats = {
    "huggingface-login" = {
      src = ./cheats;
      entry = "login.json";
    };
  };
}