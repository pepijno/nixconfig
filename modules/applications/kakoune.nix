{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kakoune
    kak-tree-sitter
    fd
    fzf
  ];
}
