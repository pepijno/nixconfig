{ pkgs, ... }:

{
  home.packages = with pkgs; [
    rsync
  ];

  systemd.user.services.backup = {
    Unit = {
      Description = "Run backup script";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "/home/pepijn/bin/create_backup /home/pepijn/ /backups";
      Environment = "PATH=/run/wrappers/bin:/home/pepijn/.nix-profile/bin:/etc/profiles/per-user/pepijn/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
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

  home.file."bin/create_backup".source = ./create_backup;
}
