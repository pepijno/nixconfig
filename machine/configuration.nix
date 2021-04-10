# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  environment.pathsToLink = [ "/libexec" ];

  nix.autoOptimiseStore = true;

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 60d";
  };

  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      ./pci-passthrough.nix
    ];

  fileSystems."/backups" =
    { device = "/dev/disk/by-uuid/2c5acd7d-98c6-44f5-b815-7611f9140b8a";
      fsType = "ext4";
    };

  swapDevices = [
    { device = "/dev/disk/by-uuid/2cd9e64a-fc4e-4dd1-9323-881982ad7bcb"; }
  ];

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelModules = ["coretemp"];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  networking.hostName = "pep-pc"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.bridges.lan.interfaces = ["enp4s0"];

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  security.doas = {
    enable = true;
    extraRules = [
      {
        users = [ "pepijn" ];
        keepEnv = true;
      }
    ];
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock-effects
    ];
  };

  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };

    displayManager.lightdm.enable = true;

    # videoDrivers = [
    #   "ati_unfree"
    #   "modesetting"
    # ];

    # useGlamor = true;
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  # hardware.pulseaudio.daemon.config.high-priority = "yes";
  # hardware.pulseaudio.daemon.config.nice-level = -15;
  # hardware.pulseaudio.daemon.config.realtime-scheduling = "yes";
  # hardware.pulseaudio.daemon.config.realtime-priority = 9;
  # hardware.pulseaudio.daemon.config.rlimit-rtprio = 9;
  # hardware.pulseaudio.daemon.config.default-sample-rate = 16000;
  # hardware.pulseaudio.daemon.config.default-sample-channels = 6;
  # hardware.pulseaudio.daemon.config.default-sample-format = "float32le";
  # hardware.pulseaudio.daemon.config.resample-method = "speex-float-10";
  # hardware.pulseaudio.daemon.config.avoid-resampling = "false";
  # hardware.pulseaudio.daemon.config.enable-remixing = "yes";
  # hardware.pulseaudio.daemon.config.remixing-use-all-sink-channels = "no";
  # hardware.pulseaudio.extraConfig = "load-module module-udev-detect tsched=0";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups.plugdev = {};
  users.users.pepijn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "kvm" "input" "libvirtd" "plugdev" ];
    shell = pkgs.fish;
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;

  services.udev = {
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
    '' ;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

