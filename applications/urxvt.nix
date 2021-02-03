{ ... }:

{
  programs.urxvt = {
    enable = true;

    fonts = [ "xft:DejaVu Sans Mono:pixelsize=15" "xft:DejaVu Sans Mono for Powerline:pixelsize=12" ];

    keybindings = {
      "Shift-Up" = "command:\\033]720;1\\007";
      "Shift-Down" = "command:\\033]721;1\\007";
      "Control-Up" = "\\033[1;5A";
      "Control-Down" = "\\033[1;5B";
      "Control-Right" = "\\033[1;5C";
      "Control-Left" = "\\033[1;5D";
    };

    scroll = {
      bar.enable = false;
      lines = 2048;
    };

    extraConfig = {
      "letterSpace" = 0;
      "geometry" = "92x24";
      "internalBorder" = 24;
      "cursorBlink" = true;
      "cursorUnderline" = false;
      "urgentOnBell" = true;
      "depth" = 32;
      "urlLauncher" = "vivaldi";
      "underlineURLs" = true;
      "urlButton" = 1;
    };
  };

  # home.file.".Xresources".source = ./Xresources;
}
