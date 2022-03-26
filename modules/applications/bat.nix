{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "ayu-light";
    };

    themes = {
      ayu-light = builtins.readFile "${pkgs.ayu-light-bat}/ayu-light.tmTheme";
    };
  };
}
