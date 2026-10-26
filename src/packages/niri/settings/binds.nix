{ ... }: {
  wayland.windowManager.niri.settings.binds = {
    # --- Overview / help / quit ---
    "Mod+Shift+Alt+Ctrl+H" = { _props = { "hotkey-overlay-title" = "Help"; }; "show-hotkey-overlay" = { }; };
    "Mod+O" = { _props = { repeat = false; "hotkey-overlay-title" = null; }; "toggle-overview" = { }; };
    "Mod+Q" = { _props = { repeat = false; "hotkey-overlay-title" = null; }; "close-window" = { }; };
    "Mod+Shift+E" = { _props = { "hotkey-overlay-title" = "Quit"; }; "quit" = { }; };
    "Ctrl+Alt+Delete" = { _props = { "hotkey-overlay-title" = null; }; "quit" = { }; };

    # --- Terminal / launcher ---
    "Mod+W" = { _props = { "hotkey-overlay-title" = "Terminal"; }; "spawn-sh" = [ "ghostty --working-directory=\"$HOME\" -e expect -c 'spawn bash; send -- \"exec \"; interact'" ]; };

    # --- Screen reader / accessibility ---
    "Super+Alt+S" = { _props = { "allow-when-locked" = true; "hotkey-overlay-title" = null; }; "spawn-sh" = [ "pkill orca || exec orca" ]; };

    # --- Volume (volumectl) ---
    "XF86AudioRaiseVolume" = { _props = { "allow-when-locked" = true; "hotkey-overlay-title" = null; }; "spawn-sh" = [ "volumectl -u up" ]; };
    "XF86AudioLowerVolume" = { _props = { "allow-when-locked" = true; "hotkey-overlay-title" = null; }; "spawn-sh" = [ "volumectl -u down" ]; };
    "XF86AudioMute" = { _props = { "allow-when-locked" = true; "hotkey-overlay-title" = null; }; "spawn-sh" = [ "volumectl toggle-mute" ]; };
    "XF86AudioMicMute" = { _props = { "allow-when-locked" = true; "hotkey-overlay-title" = null; }; "spawn-sh" = [ "volumectl -m toggle-mute" ]; };

    # --- Media (playerctl) ---
    "XF86AudioPlay" = { _props = { "allow-when-locked" = true; "hotkey-overlay-title" = null; }; "spawn-sh" = [ "playerctl play-pause" ]; };
    "XF86AudioStop" = { _props = { "allow-when-locked" = true; "hotkey-overlay-title" = null; }; "spawn-sh" = [ "playerctl stop" ]; };
    "XF86AudioPrev" = { _props = { "allow-when-locked" = true; "hotkey-overlay-title" = null; }; "spawn-sh" = [ "playerctl previous" ]; };
    "XF86AudioNext" = { _props = { "allow-when-locked" = true; "hotkey-overlay-title" = null; }; "spawn-sh" = [ "playerctl next" ]; };

    # --- Brightness (lightctl) ---
    "XF86MonBrightnessUp" = { _props = { "allow-when-locked" = true; "hotkey-overlay-title" = null; }; "spawn-sh" = [ "lightctl up" ]; };
    "XF86MonBrightnessDown" = { _props = { "allow-when-locked" = true; "hotkey-overlay-title" = null; }; "spawn-sh" = [ "lightctl down" ]; };

    # --- Focus movement ---
    "Mod+Left" = { _props = { "hotkey-overlay-title" = null; }; "focus-column-left" = { }; };
    "Mod+Down" = { _props = { "hotkey-overlay-title" = null; }; "focus-window-down" = { }; };
    "Mod+Up" = { _props = { "hotkey-overlay-title" = null; }; "focus-window-up" = { }; };
    "Mod+Right" = { _props = { "hotkey-overlay-title" = null; }; "focus-column-right" = { }; };
    "Mod+H" = { _props = { "hotkey-overlay-title" = null; }; "focus-column-left" = { }; };
    "Mod+J" = { _props = { "hotkey-overlay-title" = null; }; "focus-window-down" = { }; };
    "Mod+K" = { _props = { "hotkey-overlay-title" = null; }; "focus-window-up" = { }; };
    "Mod+L" = { _props = { "hotkey-overlay-title" = null; }; "focus-column-right" = { }; };

    # --- Move within column / workspace ---
    "Mod+Ctrl+Left" = { _props = { "hotkey-overlay-title" = null; }; "move-column-left" = { }; };
    "Mod+Ctrl+Down" = { _props = { "hotkey-overlay-title" = null; }; "move-window-down" = { }; };
    "Mod+Ctrl+Up" = { _props = { "hotkey-overlay-title" = null; }; "move-window-up" = { }; };
    "Mod+Ctrl+Right" = { _props = { "hotkey-overlay-title" = null; }; "move-column-right" = { }; };
    "Mod+Ctrl+H" = { _props = { "hotkey-overlay-title" = null; }; "move-column-left" = { }; };
    "Mod+Ctrl+J" = { _props = { "hotkey-overlay-title" = null; }; "move-window-down" = { }; };
    "Mod+Ctrl+K" = { _props = { "hotkey-overlay-title" = null; }; "move-window-up" = { }; };
    "Mod+Ctrl+L" = { _props = { "hotkey-overlay-title" = null; }; "move-column-right" = { }; };

    "Mod+Home" = { _props = { "hotkey-overlay-title" = null; }; "focus-column-first" = { }; };
    "Mod+End" = { _props = { "hotkey-overlay-title" = null; }; "focus-column-last" = { }; };
    "Mod+Ctrl+Home" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-first" = { }; };
    "Mod+Ctrl+End" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-last" = { }; };

    # --- Monitor focus / move ---
    "Mod+Shift+Left" = { _props = { "hotkey-overlay-title" = null; }; "focus-monitor-left" = { }; };
    "Mod+Shift+Down" = { _props = { "hotkey-overlay-title" = null; }; "focus-monitor-down" = { }; };
    "Mod+Shift+Up" = { _props = { "hotkey-overlay-title" = null; }; "focus-monitor-up" = { }; };
    "Mod+Shift+Right" = { _props = { "hotkey-overlay-title" = null; }; "focus-monitor-right" = { }; };
    "Mod+Shift+H" = { _props = { "hotkey-overlay-title" = null; }; "focus-monitor-left" = { }; };
    "Mod+Shift+J" = { _props = { "hotkey-overlay-title" = null; }; "focus-monitor-down" = { }; };
    "Mod+Shift+K" = { _props = { "hotkey-overlay-title" = null; }; "focus-monitor-up" = { }; };
    "Mod+Shift+L" = { _props = { "hotkey-overlay-title" = null; }; "focus-monitor-right" = { }; };

    "Mod+Shift+Ctrl+Left" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-monitor-left" = { }; };
    "Mod+Shift+Ctrl+Down" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-monitor-down" = { }; };
    "Mod+Shift+Ctrl+Up" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-monitor-up" = { }; };
    "Mod+Shift+Ctrl+Right" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-monitor-right" = { }; };
    "Mod+Shift+Ctrl+H" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-monitor-left" = { }; };
    "Mod+Shift+Ctrl+J" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-monitor-down" = { }; };
    "Mod+Shift+Ctrl+K" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-monitor-up" = { }; };
    "Mod+Shift+Ctrl+L" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-monitor-right" = { }; };

    # --- Workspaces ---
    "Mod+Page_Down" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace-down" = { }; };
    "Mod+Page_Up" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace-up" = { }; };
    "Mod+U" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace-down" = { }; };
    "Mod+I" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace-up" = { }; };
    "Mod+Ctrl+Page_Down" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace-down" = { }; };
    "Mod+Ctrl+Page_Up" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace-up" = { }; };
    "Mod+Ctrl+U" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace-down" = { }; };
    "Mod+Ctrl+I" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace-up" = { }; };
    "Mod+Shift+Page_Down" = { _props = { "hotkey-overlay-title" = null; }; "move-workspace-down" = { }; };
    "Mod+Shift+Page_Up" = { _props = { "hotkey-overlay-title" = null; }; "move-workspace-up" = { }; };
    "Mod+Shift+U" = { _props = { "hotkey-overlay-title" = null; }; "move-workspace-down" = { }; };
    "Mod+Shift+I" = { _props = { "hotkey-overlay-title" = null; }; "move-workspace-up" = { }; };

    # --- Workspace index (1-9) ---
    "Mod+1" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace" = [ 1 ]; };
    "Mod+2" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace" = [ 2 ]; };
    "Mod+3" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace" = [ 3 ]; };
    "Mod+4" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace" = [ 4 ]; };
    "Mod+5" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace" = [ 5 ]; };
    "Mod+6" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace" = [ 6 ]; };
    "Mod+7" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace" = [ 7 ]; };
    "Mod+8" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace" = [ 8 ]; };
    "Mod+9" = { _props = { "hotkey-overlay-title" = null; }; "focus-workspace" = [ 9 ]; };
    "Mod+Ctrl+1" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace" = [ 1 ]; };
    "Mod+Ctrl+2" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace" = [ 2 ]; };
    "Mod+Ctrl+3" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace" = [ 3 ]; };
    "Mod+Ctrl+4" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace" = [ 4 ]; };
    "Mod+Ctrl+5" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace" = [ 5 ]; };
    "Mod+Ctrl+6" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace" = [ 6 ]; };
    "Mod+Ctrl+7" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace" = [ 7 ]; };
    "Mod+Ctrl+8" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace" = [ 8 ]; };
    "Mod+Ctrl+9" = { _props = { "hotkey-overlay-title" = null; }; "move-column-to-workspace" = [ 9 ]; };

    # --- Column consume / expel ---
    "Mod+BracketLeft" = { _props = { "hotkey-overlay-title" = null; }; "consume-or-expel-window-left" = { }; };
    "Mod+BracketRight" = { _props = { "hotkey-overlay-title" = null; }; "consume-or-expel-window-right" = { }; };
    "Mod+Comma" = { _props = { "hotkey-overlay-title" = null; }; "consume-window-into-column" = { }; };
    "Mod+Period" = { _props = { "hotkey-overlay-title" = null; }; "expel-window-from-column" = { }; };

    # --- Column width / height / maximize ---
    "Mod+R" = { _props = { "hotkey-overlay-title" = null; }; "switch-preset-column-width" = { }; };
    "Mod+Shift+R" = { _props = { "hotkey-overlay-title" = null; }; "switch-preset-column-width-back" = { }; };
    "Mod+Ctrl+Shift+R" = { _props = { "hotkey-overlay-title" = null; }; "switch-preset-window-height" = { }; };
    "Mod+Ctrl+R" = { _props = { "hotkey-overlay-title" = null; }; "reset-window-height" = { }; };
    "Mod+F" = { _props = { "hotkey-overlay-title" = null; }; "maximize-window-to-edges" = { }; };
    "Mod+Shift+F" = { _props = { "hotkey-overlay-title" = null; }; "fullscreen-window" = { }; };
    "Mod+M" = { _props = { "hotkey-overlay-title" = null; }; "maximize-column" = { }; };
    "Mod+Ctrl+F" = { _props = { "hotkey-overlay-title" = null; }; "expand-column-to-available-width" = { }; };
    "Mod+C" = { _props = { "hotkey-overlay-title" = null; }; "center-column" = { }; };
    "Mod+Ctrl+C" = { _props = { "hotkey-overlay-title" = null; }; "center-visible-columns" = { }; };
    "Mod+Minus" = { _props = { "hotkey-overlay-title" = null; }; "set-column-width" = [ "-10%" ]; };
    "Mod+Equal" = { _props = { "hotkey-overlay-title" = null; }; "set-column-width" = [ "+10%" ]; };
    "Mod+Shift+Minus" = { _props = { "hotkey-overlay-title" = null; }; "set-window-height" = [ "-10%" ]; };
    "Mod+Shift+Equal" = { _props = { "hotkey-overlay-title" = null; }; "set-window-height" = [ "+10%" ]; };

    # --- Floating / tiling ---
    "Mod+V" = { _props = { "hotkey-overlay-title" = null; }; "toggle-window-floating" = { }; };
    "Mod+Shift+V" = { _props = { "hotkey-overlay-title" = null; }; "switch-focus-between-floating-and-tiling" = { }; };

    # --- Inhibitor escape hatch ---
    "Mod+Escape" = { _props = { "allow-inhibiting" = false; "hotkey-overlay-title" = null; }; "toggle-keyboard-shortcuts-inhibit" = { }; };

    # --- Screenshots ---
    "Print" = { _props = { "hotkey-overlay-title" = null; }; "screenshot" = { }; };
    "Ctrl+Print" = { _props = { "hotkey-overlay-title" = null; }; "screenshot-screen" = { }; };
    "Alt+Print" = { _props = { "hotkey-overlay-title" = null; }; "screenshot-window" = { }; };

    # --- Wheel scrolling ---
    "Mod+WheelScrollDown" = { _props = { "cooldown-ms" = 150; "hotkey-overlay-title" = null; }; "focus-workspace-down" = { }; };
    "Mod+WheelScrollUp" = { _props = { "cooldown-ms" = 150; "hotkey-overlay-title" = null; }; "focus-workspace-up" = { }; };
    "Mod+Ctrl+WheelScrollDown" = { _props = { "cooldown-ms" = 150; "hotkey-overlay-title" = null; }; "move-column-to-workspace-down" = { }; };
    "Mod+Ctrl+WheelScrollUp" = { _props = { "cooldown-ms" = 150; "hotkey-overlay-title" = null; }; "move-column-to-workspace-up" = { }; };
    "Mod+WheelScrollRight" = { _props = { "hotkey-overlay-title" = null; }; "focus-column-right" = { }; };
    "Mod+WheelScrollLeft" = { _props = { "hotkey-overlay-title" = null; }; "focus-column-left" = { }; };
    "Mod+Ctrl+WheelScrollRight" = { _props = { "hotkey-overlay-title" = null; }; "move-column-right" = { }; };
    "Mod+Ctrl+WheelScrollLeft" = { _props = { "hotkey-overlay-title" = null; }; "move-column-left" = { }; };
    "Mod+Shift+WheelScrollDown" = { _props = { "hotkey-overlay-title" = null; }; "focus-column-right" = { }; };
    "Mod+Shift+WheelScrollUp" = { _props = { "hotkey-overlay-title" = null; }; "focus-column-left" = { }; };
    "Mod+Ctrl+Shift+WheelScrollDown" = { _props = { "hotkey-overlay-title" = null; }; "move-column-right" = { }; };
    "Mod+Ctrl+Shift+WheelScrollUp" = { _props = { "hotkey-overlay-title" = null; }; "move-column-left" = { }; };
  };
}
