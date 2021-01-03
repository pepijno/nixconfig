{ config, pkgs, ... }:

let
  create-backup = pkgs.callPackage ./scripts/create-backup.nix { };
in {
  home.packages = [
    pkgs.rsync
    create-backup
  ];

  systemd.user.services.backup = {
    Unit = {
      Description = "Run backup script";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${create-backup}/bin/create-backup ${config.home.homeDirectory}/ /backups";
    };
  };

  systemd.user.timers.backup = {
    Unit = {
      Description = "Run backup every day";
    };

    Timer = {
      OnCalendar = "*-*-* 06:00:00";
      OnBootSec = "900";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
