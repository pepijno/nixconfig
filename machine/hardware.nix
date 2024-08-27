{ config, pkgs, ... }:

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
      extraPackages32 = with pkgs;
        [ pkgsi686Linux.libva driversi686Linux.amdvlk ]
        ++ lib.optionals config.services.pipewire.enable [ pipewire ];
    };

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
