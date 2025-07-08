{ pkgs, lib, ... }:

{
  services.pipewire.enable = lib.mkForce false;
  services.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [ amdvlk ];
      extraPackages32 =
        [ pkgs.pkgsi686Linux.libva pkgs.driversi686Linux.amdvlk ];
    };

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = { General = { Enable = "Source,Sink,Media,Socket"; }; };
    };

    xone.enable = true;
  };
}
