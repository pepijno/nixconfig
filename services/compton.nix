{ pkgs, ... }:

{ 
  services.picom = {
    enable = true;
    experimentalBackends = true;

    blur = false;

    fade = true;
    fadeDelta = 5;

    shadow = true;
    shadowOffsets = [ (-7) (-7) ];
    shadowOpacity = "0.7";
    shadowExclude = [ "window_type *= 'normal' && ! name ~= ''" ];
    noDockShadow = true;
    noDNDShadow = true;

    activeOpacity = "1.0";
    inactiveOpacity = "1.0";
    menuOpacity = "1.0";

    backend = "glx";
    vSync = true;

    extraOptions = ''
      inactive-opacity-override = false;
      shadow-radius = 7;
      clear-shadow = true;
      frame-opacity = 0.7;
      blur-strength = 5;
      detect-client-opacity = true;
      detect-rounded-corners = true;
      detect-transient = true;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
    '';
  };
}
