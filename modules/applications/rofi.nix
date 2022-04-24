{ config, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    extraConfig = {
      modi = "drun";
    };
    theme = {
      "configuration" = {
        font = "DejaVu Sans Mono Nerd Font Medium 12";
        #
        #   timeout = {
        #     delay = 10;
        #     action = "kb-cancel";
        #   };
      };

      "*" = {
        border = 0;
        margin = 0;
        padding = 0;
        spacing = 0;

        bg = mkLiteral "#2B2E37";
        bg-alt = mkLiteral "#98BE65";
        fg = mkLiteral "#B3BCCD";
        fg-alt = mkLiteral "#f8f2f2";

        background-color = mkLiteral "@bg";
        text-color = mkLiteral "@fg-alt";
      };

      "window" = {
        border = mkLiteral "2 px";
        border-color = mkLiteral "@fg-alt";
        padding = mkLiteral "6 px";
        transparency = "real";
      };

      "mainbox" = {
        children = mkLiteral "[ inputbar, listview ]";
      };

      "inputbar" = {
        children = mkLiteral "[ entry ]";
      };

      "entry" = {
        padding = mkLiteral "10 px";
      };

      "listview" = {
        lines = 10;
        scrollbar = true;
      };

      "scrollbar" = {
        # background-color = mkLiteral "@bg-alt";
        # handle-color = mkLiteral "@fg";
        # margin = mkLiteral "0 0 0 6 px";
        width = mkLiteral "0 px";
      };

      "element" = {
        children = mkLiteral "[ element-text ]";
      };

      "element-text" = {
        padding = mkLiteral "10 px";
      };

      "element-text selected" = {
        background-color = mkLiteral "@bg-alt";
        text-color = "@fg";
      };
    };
  };
}
