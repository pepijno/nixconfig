{ pkgs, config, ... }:

let
  unstable = import <nixos-unstable> {
  };
in {
  home.packages = with unstable; [
    zig
    zls
  ];

  xdg.configFile."nvim/nvim.d/zig.vim".source = ./vimrc/zig.vim;
  # xdg.configFile."nvim/parser/zig.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-zig}/parser";
}
