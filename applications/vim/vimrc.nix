{ pkgs, ... }:

let
  generic = builtins.readFile ./vimrc/general.vim;
  fzf     = builtins.readFile ./vimrc/fzf.vim;
  easymotion     = builtins.readFile ./vimrc/easymotion.vim;
  colorscheme     = builtins.readFile ./vimrc/colorscheme.vim;
in ''
${generic}

${fzf}

${easymotion}

${colorscheme}
''
