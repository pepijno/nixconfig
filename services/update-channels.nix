{ config, pkgs, ... }:

{
  systemd.user.services.update-channels = {
    Unit = {
      Description = "Update nix channels";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/nix-channel --update";
    };
  };

  systemd.user.timers.update-channels = {
    Unit = {
      Description = "Run updating of channels every hour";
    };

    Timer = {
      OnCalendar = "*-*-* 06:00:00";
      Persistent = true;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
