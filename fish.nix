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
      echo -n -s (set_color cyan)(prompt_pwd) (set_color red)\"$nix_shell_info❯\"(set_color yellow)'❯'(set_color green)'❯ '";
    };

    shellInit = ''
      set --export EDITOR "nvim -f"
      set -U fish_greeting
      cat ~/.cache/wal/sequences
    '';
  };
}
