{ config, pkgs, lib, ... }:

{
  # home.packages = with pkgs; [
  #   sirula
  # ];
  xdg.configFile."sirula/config.toml".source = ./config.toml;
  xdg.configFile."sirula/style.css".source = ./style.css;
}
