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
      echo -n -s (prompt_pwd) (set_color red)\"$nix_shell_info❯\"(set_color yellow)'❯'(set_color yellow)'❯ '";
    };

    shellAliases = {
      lvim = "/home/pepijn/.local/bin/lvim";
    };

    shellInit = ''
      set --export EDITOR "vim -f"
      set -U fish_greeting
      set -U _JAVA_AWT_WM_NONREPARENTING 1
      set FZF_DEFAULT_COMMAND "rg --files"
      if test -z "$TMUX"
        cat ~/.cache/wal/sequences
      end
    '';
  };
}
