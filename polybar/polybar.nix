{ pkgs, ... }:

{
  home.packages = with pkgs; [
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
