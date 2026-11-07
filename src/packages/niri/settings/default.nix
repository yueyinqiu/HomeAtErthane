{ config, ... }: {
  wayland.windowManager.niri.settings = {
    input = {
      keyboard = {
        xkb = { };
        numlock = { };
      };
      touchpad = {
        tap = { };
        "natural-scroll" = { };
        "scroll-factor" = 0.4;
      };
      mouse = { };
      trackpoint = { };
      "disable-power-key-handling" = { };
    };

    layout = {
      gaps = 16;
      "center-focused-column" = "never";
      "preset-column-widths" = {
        _children = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];
      };
      "default-column-width" = { proportion = 0.5; };
      "focus-ring" = {
        width = 4;
        "active-color" = "#7fc8ff";
        "inactive-color" = "#505050";
      };
      border = {
        off = { };
        width = 4;
        "active-color" = "#ffc87f";
        "inactive-color" = "#505050";
        "urgent-color" = "#9b0000";
      };
      shadow = {
        softness = 30;
        spread = 5;
        offset = { _props = { x = 0; y = 5; }; };
        "color" = "#0007";
      };
      struts = { };
    };

    "hotkey-overlay" = { };
    animations = { };
    "screenshot-path" = null;
    "spawn-sh-at-startup" = "${config.xdg.configHome}/niri/spawn-at-startup.sh";
  };

  xdg.configFile."niri/spawn-at-startup.sh" = {
    text = ''
      #!/usr/bin/env bash

      ${config.my.packages.niri}/bin/niri msg action spawn -- ${config.my.packages.qq}/bin/qq
      ${config.my.packages.niri}/bin/niri msg action spawn -- ${config.my.packages.wechat}/bin/wechat
    '';
    executable = true;
  };
}
