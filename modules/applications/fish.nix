{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    shellInit = ''
      set --export EDITOR "nvim -f"
      set -U fish_greeting
      set FZF_DEFAULT_COMMAND "rg --files"
    '';

    interactiveShellInit = ''
      if test "$TERM" != dumb
        starship init fish | source
      end
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
}
