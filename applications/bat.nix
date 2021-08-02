{ pkgs, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "ayu-light";
    };

    themes = {
      ayu-light = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "pepijno";
        repo = "ayu-light-bat"; # Bat uses sublime syntax for its themes
        rev = "95d4030b98180473262c5628ff6edb3ed9238c9d";
        sha256 = "16s4l9bvg6np2fkfzwkbkv3v5m2hsdrpn8man0586n9if5nr0xzi";
        } + "/ayu-light.tmTheme");
    };
  };
}
