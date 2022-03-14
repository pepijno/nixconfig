{ config, pkgs, ... }:

{
  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      support32Bit = true;
    };

    opengl = {
      driSupport32Bit = true;
      extraPackages32 = with pkgs.pkgsi686Linux;
        [ libva ]
        ++ lib.optionals config.services.pipewire.enable [ pipewire ];
    };

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };
}
