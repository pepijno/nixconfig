{config, pkgs, ... }:

{
  boot.kernelParams = [ "intel_iommu=on" ];

  boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];

  boot.extraModprobeConfig ="options vfio-pci ids=1002:67df,1002:aaf0";

  environment.systemPackages = with pkgs; [
    virtmanager
    qemu
    OVMF
    pciutils
    looking-glass-client
    scream-receivers
  ];

  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
  };

  users.groups.libvirtd.members = [ "root" "pepijn"];

  systemd.tmpfiles.rules = [
    "f /dev/shm/scream 0660 pepijn qemu-libvirtd -"
    "f /dev/shm/looking-glass 0660 pepijn qemu-libvirtd -"
  ];

  virtualisation.libvirtd.qemuVerbatimConfig = ''
    nvram = [
    "${pkgs.OVMF}/FV/OVMF.fd:${pkgs.OVMF}/FV/OVMF_VARS.fd"
    ]
    user = "pepijn"
    group = "kvm"
    cgroup_device_acl = [
    "/dev/kvm",
    "/dev/input/by-id/usb-ErgoDox_EZ_ErgoDox_EZ_0-event-kbd",
    "/dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse",
    "/dev/null", "/dev/full", "/dev/zero",
    "/dev/random", "/dev/urandom",
    "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
    "/dev/rtc","/dev/hpet", "/dev/sev"
    ]
  '';
}
