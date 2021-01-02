{ pkgs, ... }:

let
  # customLock = pkgs.writeScriptBin "customLock" ''
  #   cp $(sed 1d "$HOME/.fehbg" | awk '{print $4}' | tr -d "\'") /tmp/screen.png
  #   convert /tmp/screen.png -scale 10% -scale 1000% /tmp/screen.png
  #   convert /tmp/screen.png ~/bin/lockicon.png -gravity center -composite -matte /tmp/screen.png
  #   i3lock -u -i /tmp/screen.png
  #   rm /tmp/screen.png
  # '';
in {
  home.packages = [
    pkgs.libnotify
    pkgs.rofi
  ];

  services.polybar = {
    enable = true;
    package = pkgs.polybar.override {
      i3GapsSupport = true;
      alsaSupport = true;
    };
    config = ./polybar/config.ini;
    script = "~/.config/polybar/launch.sh";
  };

  home.file.".config/polybar/launch.sh".source = ./polybar/launch.sh;
  home.file.".config/polybar/scripts".source = ./polybar/scripts;
  home.file.".config/polybar/fonts".source = ./polybar/fonts;
  home.file."bin/customLock".source = ./bin/customLock;
  home.file."bin/lockicon.png".source = ./bin/lockicon.png;
}
