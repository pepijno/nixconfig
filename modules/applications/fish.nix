{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    shellInit = ''
      set --export EDITOR "nvim -f"
      set -U fish_greeting
      set FZF_DEFAULT_COMMAND "rg --files"
    '';

    plugins = [{
      name = "nix-env";
      src = pkgs.fetchFromGitHub {
        owner = "lilyball";
        repo = "nix-env.fish";
        rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
        sha256 = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
      };
    }];
  };

  programs.starship = {
    enable = true;
    settings = {
      format = ''
        [┌───────────────────](bold green) $time$all
        [│](bold green)$directory
        [└─](bold green)$character
      '';
      directory = { format = "[$path]($style)[$read_only]($read_only_style)"; };
      scan_timeout = 10;
      right_format = "$cmd_duration";
      cmd_duration = {
        min_time = 50;
      };
      directory = {
        truncation_symbol = ".../";
        fish_style_pwd_dir_length = 1;
      };
      add_newline = true;
      line_break = { disabled = true; };
      time = {
        format = "[$time]($style) ";
        disabled = false;
      };
      nix_shell = {
        style = "bold red";
        symbol = "[󱄅](bold blue) ";
      };
    };
  };
}
