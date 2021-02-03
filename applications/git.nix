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
      lola = "log --graph --decorate --pretty=online --abbrev-commit --all --date-order";
    };
  };
}
