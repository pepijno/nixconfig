{ config, pkgs, ... }:

let
  sw = "/run/current-system/sw";
in
{
  services.xidlehook = {
    enable = true;
    not-when-fullscreen = true;
    not-when-audio = true;
    timers = [
      {
        delay = 600;
        command = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
      }
      {
        delay = 600;
        command = "${sw}/bin/systemctl hibernate";
      }
    ];
  };
}
