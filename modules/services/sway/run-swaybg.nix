{ config, pkgs, ... }:

let
  kill = "/run/current-system/sw/bin/kill";
  shuf = "/run/current-system/sw/bin/shuf";
  find = "/run/current-system/sw/bin/find";
  sleep = "/run/current-system/sw/bin/sleep";
in
  pkgs.writeScriptBin "run-swaybg" ''
    #!${pkgs.stdenv.shell}
    while true; do
        PID=`pidof swaybg`
        ${pkgs.swaybg}/bin/swaybg -i $(${find} img/. -type f | ${shuf} -n1) -m fill &
        ${sleep} 1
        ${kill} $PID
        ${sleep} 599
    done
  ''
	
