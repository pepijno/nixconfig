{ config, pkgs, ... }:

let
  sw = "/run/current-system/sw";
in pkgs.writeShellScriptBin "runbar" ''
  blue=#${config.colorScheme.palette.base0D}
  black=#${config.colorScheme.palette.base05}
  green=#${config.colorScheme.palette.base0B}
  red=#${config.colorScheme.palette.base08}
  yellow=#${config.colorScheme.palette.base0A}
  pink=#${config.colorScheme.palette.base0F}
  white=#${config.colorScheme.palette.base00}
  muave=#${config.colorScheme.palette.base0E}

  pulse () {
    vol=$(${pkgs.pamixer}/bin/pamixer --get-volume)
    state=$(${pkgs.pamixer}/bin/pamixer --get-mute)

    if [ "$state" = "true" ] || [ "$vol" -eq 0 ]; then
      printf "^c$muave^^b$white^ 󰓄 "
    else
      printf "^c$muave^^b$white^ 󰓃 %s%%" "$vol"
    fi
  }

  cputemp() {
    cpu_temp="$(${pkgs.lm_sensors}/bin/sensors | ${sw}/bin/grep "Package id 0" | ${sw}/bin/awk 'NR==1{gsub("+", " "); gsub("\\..", " "); print $4}')"

    if [ "$cpu_temp" -ge 80 ]; then
      printf "^c$white^^b$red^ 󰈸 $cpu_temp°C"
    else
      printf "^c$yellow^^b$white^$cpu_temp°C"
    fi
  }

  cpu() {
    cpu_val=$(${sw}/bin/top -bn 1 | ${sw}/bin/grep '^.Cpu' | ${sw}/bin/awk '{print $2}')

    printf "^c$yellow^ ^b$white^  "
    printf %.0f $cpu_val
    printf "%%"
  }

  disk() {
    root_free=$(${sw}/bin/df -h /dev/disk/by-label/nixos | ${sw}/bin/tail -1 | ${sw}/bin/awk '{print $4}')
    home_free=$(${sw}/bin/df -h /dev/disk/by-label/home | ${sw}/bin/tail -1 | ${sw}/bin/awk '{print $4}')
    backup_free=$(${sw}/bin/df -h /dev/disk/by-label/Backups | ${sw}/bin/tail -1 | ${sw}/bin/awk '{print $4}')
    printf "^c$green^^b$white^  $root_free "
    printf "^c$green^^b$white^ 󱂵 $home_free "
    printf "^c$green^^b$white^ 󱧺 $backup_free "
  }

  mem() {
    total_ram_kbytes=$(${sw}/bin/cat /proc/meminfo | grep "MemTotal" | awk -F" " '{print $2}')
    total_ram_bytes=$(( total_ram_kbytes * 1000 ))
    available_ram_kbytes=$(${sw}/bin/cat /proc/meminfo | grep "MemAvailable" | awk -F" " '{print $2}')
    used_ram_bytes=$(( total_ram_bytes - available_ram_kbytes * 1000 ))

    total_swap_kbytes=$(${sw}/bin/cat /proc/meminfo | grep "SwapTotal" | awk -F" " '{print $2}')
    total_swap_bytes=$(( total_swap_kbytes * 1000 ))
    available_swap_kbytes=$(${sw}/bin/cat /proc/meminfo | grep "SwapFree" | awk -F" " '{print $2}')
    used_swap_bytes=$(( total_swap_bytes - available_swap_kbytes * 1000 ))

    printf "^c$red^^b$white^  %s/%s " $(${sw}/bin/numfmt --to=iec $used_ram_bytes) $(${sw}/bin/numfmt --to=iec $total_ram_bytes)
    printf "^c$red^^b$white^ 󰧑 %s/%s " $(${sw}/bin/numfmt --to=iec $used_swap_bytes) $(${sw}/bin/numfmt --to=iec $total_swap_bytes)
  }

  update_network() {
    sum=0
    for arg; do
        read -r i < "$arg"
        sum=$(( sum + i ))
    done
    cache=/tmp/''${1##*/}
    [ -f "$cache" ] && read -r old < "$cache" || old=0
    printf %d\\n "$sum" > "$cache"
    printf %d\\n $(( sum - old ))
  }

  network() {
    ip route get 8.8.8.8 &> /dev/null
    if test $? -eq 0; then
      rx=$(update_network /sys/class/net/[ew]*/statistics/rx_bytes)
      tx=$(update_network /sys/class/net/[ew]*/statistics/tx_bytes)

      printf "^c$pink^^b$white^  "
      printf "^c$pink^^b$white^%4sB" $(${sw}/bin/numfmt --to=iec $rx)
      printf "^c$pink^^b$white^  "
      printf "^c$pink^^b$white^%4sB" $(${sw}/bin/numfmt --to=iec $tx)
    else
      printf "^c$red^ ^b$white^ 󰲛 "
    fi
  }

  clock() {
    printf "^c$blue^^b$white^ 󱑆 $(${sw}/bin/date +"%F %T")"
  }

  rx_old=0
  tx_old=0
  clock_value=$(clock)
  network_value=$(network rx_old tx_old)
  mem_value=$(mem)
  disk_value=$(disk)
  cpu_temp_value=$(cputemp)
  cpu_value=$(cpu)
  pulse_value=$(pulse)

  while true; do
    interval=$((interval + 1))
    [ $(($interval % 3600)) = 0 ] && interval=0

    [ $(($interval % 1)) = 0 ] && clock_value=$(clock)
    [ $(($interval % 1)) = 0 ] && network_value=$(network rx_old tx_old)
    [ $(($interval % 2)) = 0 ] && mem_value=$(mem)
    [ $(($interval % 4)) = 0 ] && disk_value=$(disk)
    [ $(($interval % 1)) = 0 ] && cpu_temp_value=$(cputemp)
    [ $(($interval % 1)) = 0 ] && cpu_value=$(cpu)
    [ $(($interval % 2)) = 0 ] && pulse_value=$(pulse)

    ${sw}/bin/xsetroot -name "        $network_value$cpu_value $cpu_temp_value $disk_value$mem_value$pulse_value$clock_value   "
    ${sw}/bin/sleep 0.5
  done
''
