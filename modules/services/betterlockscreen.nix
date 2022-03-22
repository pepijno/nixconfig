{ config, pkgs, ... }:

let
  sleep = "/run/current-system/sw/bin/sleep";
in
{
  # services.betterlockscreen = {
  #   enable = true;
  #   inactiveInterval = 20;
  # };

  systemd.user.services.betterlockscreen = {
    Unit = {
      Description = "Lock screen when going to sleep/suspend";
      Before = [ "sleep.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    };

    Service = {
      Type = "forking";
      Environment = "DISPLAY:=0";
      ExecStart = "${pkgs.betterlockscreen}/bin/betterlockscreen --lock";
      TimeoutSec = "infinity";
      ExecStartPost = "${sleep} 1";
    };

    Install = {
      WantedBy = [ "sleep.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    };
  };
}
