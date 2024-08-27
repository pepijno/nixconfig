{ pkgs, ... }:

{
  systemd.services.upower.enable = true;

  services = {
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    xserver = {
      enable = true;
      desktopManager.xterm.enable = false;
      displayManager.startx.enable = true;
    };

    udev = {
      packages = [ pkgs.qmk-udev-rules ];
      path = [ "/etc/udev/rules.d/50-oryx.rules" ];
      extraRules = ''
      # Make an RP2040 in BOOTSEL mode writable by all users, so you can `picotool`
# without `sudo`. 
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0003", MODE="0666"

# Symlink an RP2040 running MicroPython from /dev/pico.
#
# Then you can `mpr connect $(realpath /dev/pico)`.
      SUBSYSTEM=="usb", ATTRS{idVendor}=="2e8a", ATTRS{idProduct}=="0005", SYMLINK+="uaccess"

      ACTION=="add", SUBSYSTEMS=="usb", SUBSYSTEM=="block", ENV{ID_FS_USAGE}=="filesystem", RUN{program}+="${pkgs.systemd}/bin/systemd-mount --owner=pepijn --no-block --automount=yes --collect $devnode /media/usb"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="$USER_GID", TAG+="uaccess", TAG+="udev-acl"
      '';
    };
  };
}
