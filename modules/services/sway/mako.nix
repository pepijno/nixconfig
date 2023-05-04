{ config, pkgs, lib, ... }:

{
  services.mako = {
    enable = true;
    margin = "8,0,2,0";
    borderSize = 1;
    width = 275;
    height = 95;
    format = "%s\n%b";
    layer = "overlay";
    borderRadius = 8;
    font = "Clear Sans 10.5";
    defaultTimeout = 5000;
    anchor = "top-center";
    groupBy = "summary";
    extraConfig = ''
      [urgency=normal]
      background-color=#26a269e3
      text-color=#212326
      border-color=#232525

      [urgency=critical]
      background-color=#e01b24e3
      text-color=#dedddae3
      border-color=#fb1444
      default-timeout=0
      format=<b>%s</b>\n%b

      [urgency=low]
      on-notify=exec exit
      background-color=#222322
      text-color=#b4b5b6
      border-color=#181919
    '';
  };
}
