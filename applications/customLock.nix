{ pkgs, config, ... }:

pkgs.writeScriptBin "customLock" ''
  #!${pkgs.stdenv.shell}
  # . "${config.home.homeDirectory}/.cache/wal/colors.sh"

  swaylock --daemonize --screenshots --clock --indicator --indicator-radius 100 --indicator-thickness 7 --effect-blur 7x5 --effect-vignette 0.5:0.5 --ring-color $color7 --key-hl-color $color2 --line-color $color1 --inside-color $color4 --separator-color $color5 --fade-in 0.02 --disable-caps-lock-text
''
