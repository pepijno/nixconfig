{ config, pkgs, lib, ... }:

{
  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ amdvlk ];
      extraPackages32 = 
        [ pkgs.pkgsi686Linux.libva pkgs.driversi686Linux.amdvlk ]
        ++ lib.optionals config.services.pipewire.enable [ pkgs.pipewire ];
    };

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
