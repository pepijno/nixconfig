{ config, pkgs, ... }:

{
  environment.pathsToLink = [ "/libexec" ];

  imports =
    [
      ./hardware-configuration.nix
      ./pci-passthrough.nix
      ./boot.nix
      ./services.nix
      ./hardware.nix
      ./nix.nix
      ./mullvad.nix
    ];

  networking = {
    hostName = "pep-pc";
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    iproute2.enable = true;
    wireguard.enable = true;
  };

  time.timeZone = "Europe/Amsterdam";

  security = {
    polkit.enable = true;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "pepijn" ];
          keepEnv = true;
        }
      ];
    };
    pam.services.swaylock.text = ''
      # PAM configuration file for the swaylock screen locker. By default, it includes
      # the 'login' configuration file (see /etc/pam.d/login)
      auth include login
    '';
  };

  nixpkgs.config.allowUnfree = true;

  programs = {
    git.enable = true;
    fish.enable = true;
    # steam.enable = true;
  };

  users = {
    groups.plugdev = { };
    users.pepijn = {
      isNormalUser = true;
      extraGroups = [ "wheel" "kvm" "input" "libvirtd" "plugdev" ];
      shell = pkgs.fish;
    };
  };

  system = {
    autoUpgrade.enable = true;
    autoUpgrade.allowReboot = false;
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "20.09"; # Did you read the comment?
  };

}

