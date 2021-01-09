{ config, pkgs, ... }:

let
  new-pywal = pkgs.callPackage ./scripts/new-pywal.nix { config = config; };
in {
  home.packages = [
    new-pywal
  ];
  systemd.user.services.wal = {
    Unit = {
      Description = "Run background changer";
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${new-pywal}/bin/new-pywal";
      Environment = "PATH=/run/current-system/sw/bin";
    };
  };

  systemd.user.timers.wal = {
    Unit = {
      Description = "Run background changer";
    };

    Timer = {
      OnUnitInactiveSec = "2700s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
