{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    functions = {
      fish_prompt = "test \"$USER\" = 'root'
      and echo (set_color red)\"#\"

      set -l nix_shell_info (
        if test -n \"$IN_NIX_SHELL\"
          echo -n \" <nix-shell> \"
        end
      )
      echo -n -s (set_color cyan)(prompt_pwd) (set_color red)\"$nix_shell_info❯\"(set_color yellow)'❯'(set_color yellow)'❯ '";
    };

    shellInit = ''
      set --export EDITOR "vim -f"
      set -U fish_greeting
      set FZF_DEFAULT_COMMAND "rg --files"
    '';
  };
}
