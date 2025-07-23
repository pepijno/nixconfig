{ pkgs, config, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = with config.colorScheme.palette; {
      env.TERM = "xterm-256color";

      colors = {
        primary = {
          background = "#${base00}";
          foreground = "#${base05}";
        };

        normal = {
          black = "#${base00}";
          red = "#${base08}";
          green = "#${base0B}";
          yellow = "#${base0A}";
          blue = "#${base0D}";
          magenta = "#${base0E}";
          cyan = "#${base0C}";
          white = "#${base04}";
        };

        # Bright colors
        bright = {
          black = "#${base00}";
          red = "#${base08}";
          green = "#${base0B}";
          yellow = "#${base0A}";
          blue = "#${base0D}";
          magenta = "#${base0E}";
          cyan = "#${base0C}";
          white = "#${base03}";
        };
      };

      window = {
        padding = {
          x = 25;
          y = 20;
        };
        dynamic_padding = true;
        decorations = "none";
        startup_mode = "Maximized";
        # opacity = 0.95;
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      offset = {
        x = 0.0;
        y = 0.0;
      };

      font = {
        normal = {
          family = "MesloLGS Nerd Font Mono";
        };
        bold = {
          family = "MesloLGS Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "MesloLGS Nerd Font Mono";
          style = "Italic";
        };
        # bold = {
        #   family = "DejaVu Sans Mono Nerd Font";
        #   style = "Light";
        # };
        # italic = {
        #   family = "DejaVu Sans Mono Nerd Font";
        #   style = "Italic";
        # };
        size = 11.0;
      };

      draw_bold_text_with_bright_colors = false;

      bell = {
        duration = 0;
      };

      cursor = {
        style = "Block";
        unfocused_hollow = true;
      };

      live_config_reload = true;

      keyboard.bindings = [
        {
          chars = "\u001B[13;2u";
          key = "Return";
          mods = "Shift";
        }
        {
          chars = "\u001B[13;5u";
          key = "Return";
          mods = "Control";
        }
      ];
    };
  };
}
