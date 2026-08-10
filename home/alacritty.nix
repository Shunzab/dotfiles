{
  pkgs,
  config,
  lib,
  ...
}:

{
  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        dimensions = {
          columns = 0;
          lines = 0;
        };
        padding = {
          x = 0;
          y = 0;
        };
        decorations = "None"; # Options: "Full", "None" (borderless), "Transparent"
        blur = true;
        dynamic_padding = true;
        resize_increments = true;
      };

      cursor = {
        style = {
          shape = "Block";
          blinking = "On";
        };
        unfocused_hollow = true;
        blink_interval = 500;
        vi_mode_style = {
          shape = "Underline";
          blinking = "On";
        };
      };

      mouse = {
        hide_when_typing = true;
      };

      selection = {
        save_to_clipboard = true;
      };

      scrolling = {
        history = 10000;
      };

      env = {
        TERM = "xterm-256color";
      };

      keyboard.bindings = [
        {
          key = "V";
          mods = "Control";
          action = "Paste";
        }
        {
          key = "C";
          mods = "Control|Shift";
          action = "Copy";
        }
        {
          key = "Equals";
          mods = "Control";
          action = "IncreaseFontSize";
        }
        {
          key = "Minus";
          mods = "Control";
          action = "DecreaseFontSize";
        }

        {
          key = "Key0";
          mods = "Control";
          action = "ResetFontSize";
        }
        {
          key = "Space";
          mods = "Control|Shift";
          action = "ToggleViMode";
        }
      ];
    };
  };
}
