{ ... }:

{
  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelModules = [ "kvm-intel" "coretemp" ];

    kernel = { sysctl = { "net.ipv4.ip_forward" = 1; }; };

    extraModulePackages = [ ];
  };
}
