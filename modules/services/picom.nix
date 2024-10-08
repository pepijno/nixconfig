{ ... }:

{
  services.picom = {
    enable = true;
    # blur = true;
    opacityRules = [ "100:class_i ?= 'kitty'" ];
    activeOpacity = 1.0;
    inactiveOpacity = 1.0;
    backend = "glx";
    # experimentalBackends = true;
    fade = true;
    fadeDelta = 5;
    vSync = true;
    shadow = false;
    # settings = ''
    #   detect-client-opacity = true;
    #   detect-rounded-corners = true;
    #   corner-radius = 0;
    #   round-borders = 1;
    #   blur-method = "dual_kawase";
    # '';
  };
}
