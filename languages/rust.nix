{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    rustc
    cargo
    linuxPackages.perf
    rust-analyzer
    rustfmt
  ];

  xdg.configFile."nvim/nvim.d/rust.vim".source = ./vimrc/rust.vim;
  xdg.configFile."nvim/parser/rust.so".source = "${pkgs.tree-sitter.builtGrammars.tree-sitter-rust}/parser";
}
