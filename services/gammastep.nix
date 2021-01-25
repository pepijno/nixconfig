{ config, pkgs, ... }:

{
  services.gammastep = {
    enable = true;
    tray = true;
    # Utrecht
    latitude = "52.092876";
    longitude = "5.104480";
  };
}
