{ config, pkgs, ... }:

let 
  restart-dunst = pkgs.writeScriptBin "restart-dunst" ''
    #!${pkgs.stdenv.shell}
    systemctl --user restart dunst.service
  '';
in
  pkgs.writeScriptBin "new-pywal" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.pywal}/bin/wal -i ${config.home.homeDirectory}/Pictures/Wallpapers/ -a 94 -o ${restart-dunst}/bin/restart-dunst
    source ${config.home.homeDirectory}/.cache/wal/colors.sh
    ${pkgs.betterlockscreen}/bin/betterlockscreen -u "$wallpaper"
  ''
