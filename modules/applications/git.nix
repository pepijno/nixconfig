{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Pepijn Overbeeke";
    userEmail = "pepijn.overbeeke@gmail.com";
    aliases = {
      st = "status";
      a = "add -p";
      ci = "commit";
      co = "checkout";
      s = "stash --include-untracked";
      sl = "stash list";
      sp = "stash pop";
      lol =
        "log --graph --abbrev-commit --decorate --first-parent --date-order --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
      lola =
        "log --graph --decorate --abbrev-commit --all --date-order --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
    };
  };
}
