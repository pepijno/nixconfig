# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/fd7828f0-d2bd-4fcb-a597-55e0a1edefeb";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/4e15c896-268c-4e36-84d2-c0b04e4bc358";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5474-3213";
    fsType = "vfat";
  };

  fileSystems."/backups" = {
    device = "/dev/disk/by-uuid/2c5acd7d-98c6-44f5-b815-7611f9140b8a";
    fsType = "ext4";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/2cd9e64a-fc4e-4dd1-9323-881982ad7bcb"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
}
