{ pkgs, ... }:

let
  colors = import ../colors.nix { };
in
{
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

      cursor = "${colors.cursor}";
      cursor_text_color = "${colors.cursor}";

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
      disable_ligatures = "never";
    };
    font = {
      name = "Hasklig";
      size = 11;
    };
  };
}
