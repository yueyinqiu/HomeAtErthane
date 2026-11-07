{ ... }: {
  programs.snavi.cheats = {
    "nix-airgap-airgap" = {
      src = ./cheats;
      entry = "airgap.json";
    };
  };
}
