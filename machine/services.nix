{ pkgs, ... }:

{
  systemd.services.upower.enable = true;

  services = {
    upower.enable = true;
    blueman.enable = false;

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
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      '';
    };

    openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = true;
        AllowUsers = [ "pepijn" ]; # Allows all users by default. Can be [ "user1" "user2" ]
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
      };
    };

    # undervolt = {
    #   enable = true;
    #   coreOffset = -80;
    #   gpuOffset = -80;
    # };
  };
}
