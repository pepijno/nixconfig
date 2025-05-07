{ pkgs, ... }:

let sw = "/run/current-system/sw";
in {
  home.packages = with pkgs; [ feh ];

  services.xidlehook = {
    enable = true;
    not-when-fullscreen = true;
    not-when-audio = true;
    timers = [
      # {
      #   delay = 600;
      #   command = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim -w /home/pepijn/Downloads/pixel_sakura.gif";
      # }
      {
        delay = 600;
        command = "${sw}/bin/systemctl hibernate";
      }
    ];
  };
}
