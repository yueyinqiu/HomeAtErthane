{ pkgs, nixpak, ... }: {
  my.lib.mkNixPak = nixpak.lib.nixpak {
    lib = pkgs.lib;
    pkgs = pkgs;
  };
}