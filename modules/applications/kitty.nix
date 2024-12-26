{ config, ... }:

{
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      cursor_shape = "block";
      shell_integration = "no-cursor";
      copy_on_select = "yes";

      background_opacity = "0.95";
      foreground = "#${config.colorScheme.palette.base05}";
      background = "#${config.colorScheme.palette.base00}";
      selection_foreground = "#${config.colorScheme.palette.base0F}";
      selection_background = "#${config.colorScheme.palette.base00}";

      cursor = "#${config.colorScheme.palette.base0F}";
      cursor_text_color = "#${config.colorScheme.palette.base0F}";

      color0 = "#${config.colorScheme.palette.base00}";
      color8 = "#${config.colorScheme.palette.base00}";
      color1 = "#${config.colorScheme.palette.base08}";
      color9 = "#${config.colorScheme.palette.base08}";
      color2 = "#${config.colorScheme.palette.base0B}";
      color10 = "#${config.colorScheme.palette.base0B}";
      color3 = "#${config.colorScheme.palette.base0A}";
      color11 = "#${config.colorScheme.palette.base0A}";
      color4 = "#${config.colorScheme.palette.base0D}";
      color12 = "#${config.colorScheme.palette.base0D}";
      color5 = "#${config.colorScheme.palette.base0E}";
      color13 = "#${config.colorScheme.palette.base0E}";
      color6 = "#${config.colorScheme.palette.base0C}";
      color14 = "#${config.colorScheme.palette.base0C}";
      color7 = "#${config.colorScheme.palette.base04}";
      color15 = "#${config.colorScheme.palette.base03}";

      background_blur = "40";

      term = "xterm-256color";

      window_padding_width = "15";
      disable_ligatures = "never";
      font_features = ''
        FiraCodeRoman-Regular +ss01 +ss02 +ss03 +ss04 +ss05 +ss07 +cv02 +cv30
        font_features FiraCodeRoman-Bold +ss01 +ss02 +ss03 +ss04 +ss05 +ss07 +cv02 +cv30
        font_features FiraCodeRoman-SemiBold +ss01 +ss02 +ss03 +ss04 +ss05 +ss07 +cv02 +cv30
        font_features FiraCodeRoman-Medium +ss01 +ss02 +ss03 +ss04 +ss05 +ss07 +cv02 +cv30'';
    };
    font = {
      name = "Fira Code";
      size = 11;
    };
  };
}
