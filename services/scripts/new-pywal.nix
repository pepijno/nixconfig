{ config, pkgs, ... }:

let
  restart-dunst = pkgs.writeScriptBin "restart-dunst" ''
  '';
  date = "/run/current-system/sw/bin/date";
  systemctl = "/run/current-system/sw/bin/systemctl";
in
  pkgs.writeScriptBin "new-pywal" ''
    #!${pkgs.stdenv.shell}
    currentminute=$(${date} +%M)
    if [[ "$currentminute" == "00" ]]; then
      currenttime=$(${date} +%H:%M)
      params=()
      if [[ "$currenttime" < "20:00" ]] && [[ "$currenttime" > "08:00" ]]; then
        params+=(-l -a 86)
      else
        params+=(-a 94)
      fi
      ${pkgs.pywal}/bin/wal \
        -i ${config.home.homeDirectory}/Pictures/Wallpapers/ \
        -o ${restart-dunst}/bin/restart-dunst \
        "''${params[@]}"
    fi
    ${pkgs.pywal}/bin/wal -R
    source ${config.home.homeDirectory}/.cache/wal/colors.sh
    ${pkgs.betterlockscreen}/bin/betterlockscreen -u "$wallpaper"
  ''
