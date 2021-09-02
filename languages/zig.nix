{ pkgs, config, ... }:

let
  unstable = import <nixos-unstable> {
  };
in {
  home.packages = with unstable; [
    zig
    zls
  ];
}
