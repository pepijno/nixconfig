{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    cmake
    gcc
    ccls
    # bintools-unwrapped
  ];

  xdg.configFile."nvim/nvim.d/cpp.vim".source = ./vimrc/cpp.vim;
  xdg.configFile."nvim/parser/cpp.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-cpp}/parser";
}
