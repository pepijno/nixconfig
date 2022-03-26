{ config, pkgs, fetchurl, lib, ... }:

{
  services.mullvad-vpn.enable = true;

  environment.systemPackages = with pkgs; [
    mullvad-vpn
  ];
}
