{ pkgs, ... }:

let
  colors = import ../colors.nix { };
in
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";

      colors = {
        primary = {
          background = colors.background;
          foreground = colors.foreground;
        };

        normal = {
          black = colors.black;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.purple;
          cyan = colors.aqua;
          white = colors.white;
        };

        # Bright colors
        bright = {
          black = colors.bright_black;
          red = colors.bright_red;
          green = colors.bright_green;
          yellow = colors.bright_yellow;
          blue = colors.bright_blue;
          magenta = colors.bright_purple;
          cyan = colors.bright_aqua;
          white = colors.bright_white;
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
        opacity = 0.95;
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
          family = "Fira Code";
          style = "Regular";
        };
        bold = {
          family = "Fira Code";
          style = "Bold";
        };
        italic = {
          family = "Fira Code";
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
    };
  };

  programs.kitty = {
    enable = true;
    # theme = "Gruvbox Material Light Soft";
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      cursor_shape = "block";
      shell_integration = "no-cursor";
      copy_on_select = "yes";

      background_opacity = "0.95";
      foreground = "${colors.foreground}";
      background = "${colors.background}";
      selection_foreground = "${colors.background}";
      selection_background = "${colors.foreground}";

      cursor = "${colors.bright_black}";
      cursor_text_color = "background";

      color0 = "${colors.black}";
      color8 = "${colors.bright_black}";
      color1 = "${colors.red}";
      color9 = "${colors.bright_red}";
      color2 = "${colors.green}";
      color10 = "${colors.bright_green}";
      color3 = "${colors.yellow}";
      color11 = "${colors.bright_yellow}";
      color4 = "${colors.blue}";
      color12 = "${colors.bright_blue}";
      color5 = "${colors.purple}";
      color13 = "${colors.bright_purple}";
      color6 = "${colors.aqua}";
      color14 = "${colors.bright_aqua}";
      color7 = "${colors.white}";
      color15 = "${colors.bright_white}";

      background_blur = "40";

      term = "xterm-256color";

      window_padding_width = "15";
    };
    font = {
      name = "Fira Code";
      size = 11;
    };
  };
}
