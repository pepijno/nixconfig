{ pkgs, ... }:

let
  sleep = "/run/current-system/sw/bin/sleep";
  ip = "/run/current-system/sw/bin/ip";
  awk = "/run/current-system/sw/bin/awk";
  ping = "/run/current-system/sw/bin/ping";
  echo = "/run/current-system/sw/bin/echo";
in
  pkgs.writeScriptBin "check-network" ''
    #!${pkgs.stdenv.shell}
    count=0
    disconnected="睊"
    wireless_connected="直"
    ethernet_connected="泌"

    ID="$(${ip} link | ${awk} '/state UP/ {print $2}')"

    while true; do
        if (${ping} -c 1 archlinux.org || ${ping} -c 1 bitbucket.org || ${ping} -c 1 github.com || ${ping} -c 1 sourceforge.net) &>/dev/null; then
            if [[ $ID == e* ]]; then
                ${echo} "$ethernet_connected" ; ${sleep} 25
            else
                ${echo} "$wireless_connected" ; ${sleep} 25
            fi
        else
            ${echo} "$disconnected" ; ${sleep} 0.5
        fi
    done
  ''
