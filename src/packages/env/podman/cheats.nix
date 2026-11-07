{ ... }: {
  programs.snavi.cheats = {
    "podman-podman" = {
      src = ./cheats;
      entry = "podman.json";
    };
  };
}
