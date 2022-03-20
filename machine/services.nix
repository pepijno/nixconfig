{ config, pkgs, ... }:

{
  services = {
    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        lightdm = {
          enable = true;
        };
        autoLogin = {
          enable = true;
          user = "pepijn";
        };
      };

      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          i3lock #default i3 screen locker
        ];
      };
    };

    udev = {
      path = [ "/etc/udev/rules.d/50-oryx.rules" ];
      extraRules = ''
        # Rule for the Moonlander
        SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", TAG+="uaccess", TAG+="udev-acl"
        # Rule for the Ergodox EZ Original / Shine / Glow
        SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", TAG+="uaccess", TAG+="udev-acl"
        # Rule for the Planck EZ Standard / Glow
        SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", TAG+="uaccess", TAG+="udev-acl"

        # Teensy rules for the Ergodox EZ Original / Shine / Glow
        ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
        ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
        KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

        # STM32 rules for the Moonlander and Planck EZ Standard / Glow
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
            MODE:="0666", \
            SYMLINK+="stm32_dfu"

        SUBSYSTEM=="input", GROUP="input", MODE="0666"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="cdcd", ATTRS{idProduct}=="7575", MODE:="0666", GROUP="plugdev"
        KERNEL=="hidraw*", ATTRS{idVendor}=="cdcd", ATTRS{idProduct}=="7575", MODE="0666", GROUP="plugdev"
      '';
    };
  };
}
