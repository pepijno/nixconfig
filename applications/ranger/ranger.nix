{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ranger
  ];

  xdg.configFile."ranger/rc.conf".source = ./rc.conf;
  xdg.configFile."ranger/commands.py".source = ./commands.py;
}
