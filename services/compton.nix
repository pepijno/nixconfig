{ config, pkgs, ... }:

{ 
  services.picom = {
    enable = true;
    package = pkgs.nur.repos.reedrw.picom-next-ibhagwan;
    backend = "glx";
    experimentalBackends = true;
    fade = true;
    fadeDelta = 5;
    activeOpacity = "1.0";
    inactiveOpacity = "1.0";
    extraOptions = ''
      detect-client-opacity = true;
      detect-rounded-corners = true;
      corner-radius = 4;
      round-borders = 1;
    '';
  };
  # services.picom = {
  #   package = pkgs.nur.repos.reedrw.picom-next-ibhagwan;
  #   enable = true;
  #   activeOpacity = "1.0";
  #   inactiveOpacity = "1.0";
  #   backend = "glx";
  #   fade = true;
  #   fadeDelta = 5;
  #   opacityRule = [ "100:name *= 'i3lock'" ];
  #   shadow = true;
  #   shadowOpacity = "0.75";
  #   extraOptions = ''
  #     detect-client-opacity = true;
  #     detect-rounded-corners = true;
  #     round-borders = 1;
  #   '';
  # };
}
