{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";
    experimentalBackends = true;
    fade = true;
    fadeDelta = 5;
    activeOpacity = "1.0";
    inactiveOpacity = "1.0";
    vSync = true;
    extraOptions = ''
      detect-client-opacity = true;
      detect-rounded-corners = true;
      corner-radius = 0;
      round-borders = 1;
      blur-method = "dual_kawase";
    '';
  };
}
