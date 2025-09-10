{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    ubuntu-classic
    # nerdfonts
    nerd-fonts.meslo-lg
    fira-code
    mononoki
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
