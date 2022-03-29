{ config, pkgs, ... }:

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
        command = "systemctl hibernate";
      }
    ];
  };
}
