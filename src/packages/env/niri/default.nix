{
  pkgs,
  niri,
  config,
  ...
}:
{
  wayland.windowManager.niri = {
    enable = true;
    package = niri.niri-unstable;
    enableDefaultConfig = false;
  };

  my.packages.niri = config.wayland.windowManager.niri.package;

  xdg.portal.config.niri = {
    default = [ "gnome" ];
    "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "n";
      text = ''
        exec ${config.my.packages.niri}/bin/niri-session
      '';
    })
  ];
}
