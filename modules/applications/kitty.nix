{ pkgs, config, ... }:

{
  programs.kitty = {
    enable = true;
    # theme = "Gruvbox Material Light Soft";
    settings = with config.colorScheme.colors; {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
      cursor_shape = "block";
      shell_integration = "no-cursor";
      copy_on_select = "yes";

      background_opacity = "0.95";
      foreground = "#${base05}";
      background = "#${base00}";
      selection_foreground = "#${base0F}";
      selection_background = "#${base00}";

      cursor = "#${base0F}";
      cursor_text_color = "#${base0F}";

      color0 = "#${base00}";
      color8 = "#${base00}";
      color1 = "#${base08}";
      color9 = "#${base08}";
      color2 = "#${base0B}";
      color10 = "#${base0B}";
      color3 = "#${base0A}";
      color11 = "#${base0A}";
      color4 = "#${base0D}";
      color12 = "#${base0D}";
      color5 = "#${base0E}";
      color13 = "#${base0E}";
      color6 = "#${base0C}";
      color14 = "#${base0C}";
      color7 = "#${base04}";
      color15 = "#${base03}";

      background_blur = "40";

      term = "xterm-256color";

      window_padding_width = "15";
      disable_ligatures = "never";
      font_features = "FiraCodeRoman-Regular +ss01 +ss02 +ss03 +ss04 +ss05 +ss07 +cv02 +cv30\nfont_features FiraCodeRoman-Bold +ss01 +ss02 +ss03 +ss04 +ss05 +ss07 +cv02 +cv30\nfont_features FiraCodeRoman-SemiBold +ss01 +ss02 +ss03 +ss04 +ss05 +ss07 +cv02 +cv30\nfont_features FiraCodeRoman-Medium +ss01 +ss02 +ss03 +ss04 +ss05 +ss07 +cv02 +cv30";
    };
    font = {
      name = "Fira Code";
      size = 11;
    };
  };
}
