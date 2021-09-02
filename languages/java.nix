{ pkgs, config, ... }:

let
  unstable = import <nixos-unstable> {};
in {
  home.packages = [
    pkgs.gradle
    pkgs.jdk11
    unstable.java-language-server
  ];

/*   xdg.configFile."nvim/nvim.d/java.vim".source = ./vimrc/java.vim; */
/*   xdg.configFile."nvim/parser/java.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-java}/parser"; */
}
