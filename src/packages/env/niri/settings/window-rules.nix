{ ... }: {
  wayland.windowManager.niri.settings._children = [
    {
      "window-rule" = {
        match = {
          _props = {
            "app-id" = "com.mitchellh.ghostty";
          };
        };
        "open-maximized-to-edges" = true;
      };
    }
    {
      "window-rule" = {
        match = {
          _props = {
            "app-id" = "wpsoffice";
          };
        };
        "open-fullscreen" = false;
        "open-maximized-to-edges" = true;
      };
    }
    {
      "window-rule" = {
        match = {
          _props = {
            "app-id" = "wpp";
          };
        };
        "open-floating" = true;
      };
    }
    {
      "window-rule" = {
        match = {
          _props = {
            "app-id" = "code";
          };
        };
        "open-maximized-to-edges" = true;
      };
    }
    {
      "window-rule" = {
        match = {
          _props = {
            "app-id" = "steam";
          };
        };
        "open-fullscreen" = false;
        "open-maximized-to-edges" = true;
      };
    }
  ];
}
