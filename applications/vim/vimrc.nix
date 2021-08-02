{ pkgs, ... }:

let
  generic = builtins.readFile ./vimrc/general.vim;
  fzf     = builtins.readFile ./vimrc/fzf.vim;
  easymotion     = builtins.readFile ./vimrc/easymotion.vim;
  colorscheme     = builtins.readFile ./vimrc/colorscheme.vim;
  rust     = builtins.readFile ./vimrc/rust.vim;
in ''
${generic}

${fzf}

${easymotion}

${colorscheme}

${rust}
''
