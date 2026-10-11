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
  xdg.portal.config.niri = {
    default = [ "gnome" ];
    "org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
  };

  home.packages = [
    (pkgs.writeShellApplication {
      name = "n";
      text = ''
        exec ${config.wayland.windowManager.niri.package}/bin/niri-session
      '';
    })
  ];
}
