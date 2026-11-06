{ config, lib, pkgs, ... }:
let
  fakeFlatpak = pkgs.writeShellApplication {
    name = "flatpak";
    text = "echo read-write";
  };

  path = lib.concatStringsSep ":" [
    "${fakeFlatpak}/bin"
    "/run/wrappers/bin"
    "${config.home.homeDirectory}/.nix-profile/bin"
    "/nix/profile/bin"
    "${config.home.homeDirectory}/.local/state/nix/profile/bin"
    "/etc/profiles/per-user/${config.home.username}/bin"
    "/nix/var/nix/profiles/default/bin"
    "/run/current-system/sw/bin"
  ];
in
{
  xdg.configFile."systemd/user/xdg-document-portal.service.d/nixpak-fake-flatpak.conf".text = ''
    [Service]
    Environment=PATH=${path}
  '';
}