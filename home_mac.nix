{ pkgs, inputs, ... }:

{
  imports = [
    ./modules/fonts.nix

    ./modules/applications/jj.nix
    ./modules/applications/git.nix
    ./modules/applications/alacritty.nix
    ./modules/applications/tmux.nix

    ./modules/applications/neovim.nix
    ./modules/applications/fish.nix
    ./modules/applications/oh-my-posh.nix

    inputs.nix-colors.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    # bat
    fd
    nix-prefetch-git
    fzf
    ripgrep
    fd
    wget

    asm-lsp
    asmfmt
    zig
    zls
    ormolu
    haskell-language-server
    clang-tools
    bash-language-server
    beautysh
    stylua
    nixd
    nixfmt
    fish-lsp
    lua-language-server
    jq
    lemminx
    libxml2 # xmllint
    jdt-language-server
    fennel-ls
    fnlfmt

    direnv

    librewolf
    emacs
  ];

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-latte;

  nixpkgs.config.allowUnfree = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "poverbeeke";
  home.homeDirectory = "/Users/poverbeeke";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";
}
