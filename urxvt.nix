{ ... }:

{
  programs.urxvt = {
    enable = true;

    fonts = [ "xft:DejaVu Sans Mono:pixelsize=15" ];

    transparent = false;
  };

  home.file.".Xresources".source = ./Xresources;
}
