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
      echo -n -s [(set_color green)(date '+%T')(set_color white)]-[(set_color yellow)(prompt_pwd)(set_color white)]-(set_color red)\"$nix_shell_info❯\"(set_color yellow)'❯'(set_color blue)'❯ '";
    };

    shellAliases = {
      lvim = "/home/pepijn/.local/bin/lvim";
      vim = "/home/pepijn/.local/bin/lvim";
    };

    shellInit = ''
      set --export EDITOR "/home/pepijn/.local/bin/lvim -f"
      set -U fish_greeting
      set FZF_DEFAULT_COMMAND "rg --files"
      if test -z "$TMUX"
        cat ~/.cache/wal/sequences
      end
    '';
  };
}
