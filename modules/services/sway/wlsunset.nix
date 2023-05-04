{ config, pkgs, lib, ... }:

{
  services.wlsunset = {
    enable = true;
    # Utrecht
    latitude = "52.092876";
    longitude = "5.104480";
    temperature = {
      day = 5500;
      night = 3000;
    };

  };
}
