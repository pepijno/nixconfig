{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    functions = {
      fish_prompt = "
        set -l nix_shell_info (
          if test -n \"$IN_NIX_SHELL\"
            echo -n \" <nix-shell> \"
          end
        )
        echo -n -s \\((set_color green)(date '+%T')(set_color white)\\)-\\((set_color yellow)(prompt_pwd)(set_color white)\\)-(set_color red)\"$nix_shell_info❯\"(set_color yellow)'❯'(set_color blue)'❯ '(set_color -o normal)
      ";
      fish_right_prompt = ''
        set -l color_green  (set_color green)
        set -l color_dim    (set_color white)
        set -l color_off    (set_color -o normal)

        echo -n -s $color_dim (date +%H$color_green:$color_dim%M$color_green:$color_dim%S)$color_off
      '';
      fish_title = ''
        echo "$PWD | $_" | sed "s|$HOME|~|g"
      '';
    };

    shellAliases = {
      lvim = "/home/pepijn/.local/bin/lvim";
    };

    shellInit = ''
      set --export EDITOR "nvim -f"
      set -U fish_greeting
      set FZF_DEFAULT_COMMAND "rg --files"
    '';

    plugins = [
      {
        name = "nix-env";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          sha256 = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
        };
      }
    ];
  };
}
