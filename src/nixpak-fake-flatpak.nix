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
  # Most apps don't properly support flatpak's document portal. Notably,
  # Chromium/Electron's "write a temp file then rename" atomic save doesn't work
  # on the portal's FUSE mount, leaving behind only a placeholder file.
  # We install a fake `flatpak` here, so that the `flatpak info --file-access`
  # call xdg-document-portal makes always returns "read-write". The portal then
  # assumes the app has direct read/write access and returns the real path,
  # bypassing the document portal's FUSE-export indirection.
  # Actual access is still enforced by each app's bwrap binds, so this lie is safe.
  # https://github.com/nixpak/nixpak/issues/62
  xdg.configFile."systemd/user/xdg-document-portal.service.d/nixpak-fake-flatpak.conf".text = ''
    [Service]
    Environment=PATH=${path}
  '';
}