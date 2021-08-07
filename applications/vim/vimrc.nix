{ pkgs, ... }:

let
  general     = builtins.readFile ./vimrc/general.vim;
  bindings    = builtins.readFile ./vimrc/bindings.vim;
  colorscheme = builtins.readFile ./vimrc/colorscheme.vim;
  plugins     = builtins.readFile ./vimrc/plugins.vim;
in ''
${general}

${bindings}

${colorscheme}

${plugins}
''
