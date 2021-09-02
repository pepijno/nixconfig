{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    gcc
	clang-tools
  ];
}
