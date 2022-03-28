{ config, pkgs, ... }:

{

  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
    xautolock = {
      extraOptions = [
        "Xautolock.killer: systemctl suspend"
      ];
    };
  };
}
