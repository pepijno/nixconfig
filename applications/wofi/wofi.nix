{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wofi
  ];

  xdg.configFile."wofi/style.css".source = ./style.css;
}
