{ ... }:

{
  programs.fish = {
    enable = true;

    functions = {
      fish_prompt = "test \"$USER\" = 'root'
      and echo (set_color red)\"#\"

      echo -n (set_color cyan)(prompt_pwd) (set_color red)'❯'(set_color yellow)'❯'(set_color green)'❯ '";
    };

    shellInit = ''
      set --export EDITOR "nvim -f"
      set -U fish_greeting
    '';
  };
}
