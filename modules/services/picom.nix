{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    # blur = true;
    opacityRule = [ "91:class_i ?= 'alacritty'" ];
    activeOpacity = "1.0";
    inactiveOpacity = "1.0";
    backend = "glx";
    experimentalBackends = true;
    fade = true;
    fadeDelta = 5;
    vSync = true;
    shadow = false;
    settings = ''
      detect-client-opacity = true;
      detect-rounded-corners = true;
      corner-radius = 0;
      round-borders = 1;
      blur-method = "dual_kawase";
    '';
  };
}
