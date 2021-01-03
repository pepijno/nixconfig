{ pkgs, ... }:

let
  echo = "/run/current-system/sw/bin/echo";
  ls = "/run/current-system/sw/bin/ls";
  mountpoint = "/run/current-system/sw/bin/mountpoint";
  date = "/run/current-system/sw/bin/date";

in
  pkgs.writeScriptBin "create-backup" ''
    #!${pkgs.stdenv.shell}
    function send_message {
        eval "XDG_RUNTIME_DIR=/run/user/$(id -u) $(command -v ${pkgs.libnotify}/bin/notify-send) \"$2\" \"$(${echo} -e $3)\" -u $1"
    }

    function show_fail {
        send_message "critical" "Backup failed" "Could not create backup:\n'$1'\n\nPlease fix and run the backup manually."
    }

    function show_success {
        send_message "normal" "Backup created" "Backup created succesfully"
    }

    function dir_exists {
        ${ls} $1 1> /dev/null 2>&1
        return $?
    }

    if [ $# -ne 2 ]; then
        show_fail "Please provide 2 arguments to backup script"
        exit 1;
    fi

    bkp_dir=$2
    source_dir=$1

    if [ ! -d $bkp_dir ]; then
        show_fail "Backup directory $bkp_dir does not exist."
        exit 1;
    fi

    ${mountpoint} $bkp_dir &> /dev/null

    if [ $? -ne 0 ]; then
        show_fail "Directory $bkp_dir does not have a partition mounted."
        exit 1;
    fi

    if [ ! -d $source_dir ]; then
        show_fail "Source directory $source_dir does not exist."
        exit 1;
    fi

    time=$(${date} +%Y-%m-%d_%T)

    prev=0
    for ((i=0;i<30;i+=1)); do
        d=$(${date} -d "$date -$i days" +"%Y-%m-%d")
        dir="$bkp_dir/$d*"
        dir_exists $dir
        if [ $? -eq 0 ]; then
            files=( $dir )
            prev="''${files[0]}"
        fi
        if [ "$prev" != "0" ]; then
            break;
        fi
    done

    if [ "$prev" == "0" ]; then
        ${echo} "Creating full backup..."
        ${pkgs.rsync}/bin/rsync \
            --archive \
            --one-file-system \
            --hard-links \
            --human-readable \
            --inplace \
            --numeric-ids \
            $source_dir \
            $bkp_dir/full_$time
        if [ $? -ne 0 ]; then
            show_fail "Full-backup creation failed, rsync command did not complete."
            exit 1
        else
            show_success
        fi
    else
        ${echo} "Creating partial backup..."
        ${pkgs.rsync}/bin/rsync \
            --archive \
            --one-file-system \
            --hard-links \
            --human-readable \
            --inplace \
            --numeric-ids \
            --delete \
            --link-dest=$prev \
            $source_dir \
            $bkp_dir/$time
        if [ $? -ne 0 ]; then
            show_fail "Backup creation failed, rsync command did not complete."
            exit 1
        else
            show_success
        fi
    fi
  ''
