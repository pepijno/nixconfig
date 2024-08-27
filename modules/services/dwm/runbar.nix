{ config, pkgs, ...}:

let
  sw = "/run/current-system/sw";
  network_speed = pkgs.callPackage ./network_speed.nix { config = config; };
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
      previous_date="$current_date"
      previous_stats="$current_stats"
      current_date=$(${sw}/bin/date +%s%N | ${sw}/bin/cut -b1-13)
      current_stats=$(${sw}/bin/cat /proc/stat | ${sw}/bin/head -1)

      user=$(echo "$current_stats" | ${sw}/bin/awk -F " " '{print $2}')
      nice=$(echo "$current_stats" | ${sw}/bin/awk -F " " '{print $3}')
      system=$(echo "$current_stats" | ${sw}/bin/awk -F " " '{print $4}')
      idle=$(echo "$current_stats" | ${sw}/bin/awk -F " " '{print $5}')
      iowait=$(echo "$current_stats" | ${sw}/bin/awk -F " " '{print $6}')
      irq=$(echo "$current_stats" | ${sw}/bin/awk -F " " '{print $7}')
      softirq=$(echo "$current_stats" | ${sw}/bin/awk -F " " '{print $8}')
      steal=$(echo "$current_stats" | ${sw}/bin/awk -F " " '{print $9}')

      prevuser=$(echo "$previous_stats" | ${sw}/bin/awk -F " " '{print $2}')
      prevnice=$(echo "$previous_stats" | ${sw}/bin/awk -F " " '{print $3}')
      prevsystem=$(echo "$previous_stats" | ${sw}/bin/awk -F " " '{print $4}')
      previdle=$(echo "$previous_stats" | ${sw}/bin/awk -F " " '{print $5}')
      previowait=$(echo "$previous_stats" | ${sw}/bin/awk -F " " '{print $6}')
      previrq=$(echo "$previous_stats" | ${sw}/bin/awk -F " " '{print $7}')
      prevsoftirq=$(echo "$previous_stats" | ${sw}/bin/awk -F " " '{print $8}')
      prevsteal=$(echo "$previous_stats" | ${sw}/bin/awk -F " " '{print $9}')

      PrevIdle=$((previdle + previowait))
      Idle=$((idle + iowait))

      PrevNonIdle=$((prevuser + prevnice + prevsystem + previrq + prevsoftirq + prevsteal))
      NonIdle=$((user + nice + system + irq + softirq + steal))

      PrevTotal=$((PrevIdle + PrevNonIdle))
      Total=$((Idle + NonIdle))

      totald=$((Total - PrevTotal))
      idled=$((Idle - PrevIdle))

      cpu_val=$(${sw}/bin/awk "BEGIN {print ($totald - $idled)/$totald*100}" | ${pkgs.busybox}/bin/bc -l)

      printf "^c$yellow^ ^b$white^  "
      printf %.0f $cpu_val
      printf "%%"
    }

    disk() {
      root_free=$(${sw}/bin/df -h /dev/sda1 | ${sw}/bin/tail -1 | ${sw}/bin/awk '{print $4}')
      home_free=$(${sw}/bin/df -h /dev/sda2 | ${sw}/bin/tail -1 | ${sw}/bin/awk '{print $4}')
      backup_free=$(${sw}/bin/df -h /dev/sdb1 | ${sw}/bin/tail -1 | ${sw}/bin/awk '{print $4}')
      printf "^c$green^^b$white^  $root_free "
      printf "^c$green^^b$white^ 󱂵 $home_free "
      printf "^c$green^^b$white^ 󱧺 $backup_free "
    }

    mem() {
      total_ram=$(${sw}/bin/free -mh --si | ${sw}/bin/grep Mem | ${sw}/bin/awk  {'print $2'})
      used_ram=$(${sw}/bin/free -mh --si | ${sw}/bin/grep Mem | ${sw}/bin/awk  {'print $3'})
      total_swap=$(${sw}/bin/free -mh --si | ${sw}/bin/grep Swap | ${sw}/bin/awk  {'print $2'})
      used_swap=$(${sw}/bin/free -mh --si | ${sw}/bin/grep Swap | ${sw}/bin/awk  {'print $3'})
      printf "^c$red^^b$white^  $used_ram/$total_ram "
      printf "^c$red^^b$white^ 󰧑 $used_swap/$total_swap "
    }

    network() {
      ip route get 8.8.8.8 &> /dev/null
      if test $? -eq 0; then
        up=$(${network_speed}/bin/network_speed up)
        down=$(${network_speed}/bin/network_speed down)
        printf "^c$pink^^b$white^  "
        printf "^c$pink^^b$white^$down"
        printf "^c$pink^^b$white^  "
        printf "^c$pink^^b$white^$up"
      else
        printf "^c$red^ ^b$white^ 󰲛 "
      fi
    }

    clock() {
      printf "^c$blue^^b$white^ 󱑆 $(${sw}/bin/date +"%F %T")"
    }

    clock_value=$(clock)
    network_value=$(network)
    mem_value=$(mem)
    disk_value=$(disk)
    cpu_temp_value=$(cputemp)
    cpu
    cpu_value=$(cpu)
    pulse_value=$(pulse)

    while true; do
      interval=$((interval + 1))
      [ $(($interval % 3600)) = 0 ] && interval=0

      [ $(($interval % 1)) = 0 ] && clock_value=$(clock)
      [ $(($interval % 2)) = 0 ] && network_value=$(network)
      [ $(($interval % 5)) = 0 ] && mem_value=$(mem)
      [ $(($interval % 5)) = 0 ] && disk_value=$(disk)
      [ $(($interval % 2)) = 0 ] && cpu_temp_value=$(cputemp)
      [ $(($interval % 2)) = 0 ] && cpu_value=$(cpu)
      [ $(($interval % 2)) = 0 ] && pulse_value=$(pulse)

      ${sw}/bin/xsetroot -name "$network_value$cpu_value $cpu_temp_value $disk_value$mem_value$pulse_value$clock_value   "
      ${sw}/bin/sleep 1
    done
  ''
