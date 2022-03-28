{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    activeOpacity = "1.0";
    inactiveOpacity = "0.8";
    backend = "glx";
    experimentalBackends = true;
    fade = true;
    fadeDelta = 5;
    vSync = true;
    shadow = false;
    extraOptions = ''
      detect-client-opacity = true;
      detect-rounded-corners = true;
      corner-radius = 0;
      round-borders = 1;
      blur-method = "dual_kawase";
    '';
  };
}
