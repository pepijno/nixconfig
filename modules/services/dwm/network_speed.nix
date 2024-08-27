{ config, pkgs, ... }:

let
  sw = "/run/current-system/sw";
  grep = "${pkgs.gnugrep}/bin/grep";
in
  pkgs.writeShellScriptBin "network_speed" ''
    function get_bytes {
        local interface=$(${sw}/bin/route | ${grep} '^default' | ${grep} -o '[^ ]*$')
        local bytes_concat_args=$(${grep} ''${interface:-lo} /proc/net/dev | ${sw}/bin/cut -d ':' -f 2 | ${sw}/bin/awk -v rb="$1" -v tb="$2" '{print rb"="$1, tb"="$9}')
        eval $bytes_concat_args
    }

    function get_velocity {
        local timediff=$(($3 - $4))
        local vel_kb=$(echo "1000000000 * ($1 - $2) / 1024 / $timediff" | ${pkgs.busybox}/bin/bc)
        if test "$vel_kb" -gt 1024; then
            echo $(echo "scale = 2; $vel_kb / 1024" | ${pkgs.busybox}/bin/bc)MB/s
        else
            echo $vel_kb"KB/s"
        fi
    }

    function dwm_network_speed_record {
        get_bytes 'received_bytes' 'transmitted_bytes'
        old_received_bytes=$received_bytes
        old_transmitted_bytes=$transmitted_bytes

        old_time=$(date +%s%N)
    }

    function download_speed {
        get_velocity $received_bytes $old_received_bytes $now $old_time
    }

    function upload_speed {
        get_velocity $transmitted_bytes $old_transmitted_bytes $now $old_time
    }

    function dwm_network_speed {
        get_bytes 'received_bytes' 'transmitted_bytes'
        now=$(date +%s%N)

        if [ "$1" == "up" ]; then
          printf "%s" "$(upload_speed)"
        else
          printf "%s" "$(download_speed)"
        fi
    }

    dwm_network_speed_record
    dwm_network_speed $1
  ''
