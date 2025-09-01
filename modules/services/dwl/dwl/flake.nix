{
  description = "vix";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages."${system}";

        buildInputs = with pkgs; [
          installShellFiles
          pkg-config
          wayland-scanner
          libinput
          xorg.libxcb
          libxkbcommon
          pixman
          wayland
          wayland-protocols
          wlroots_0_18
          xorg.libX11
          xorg.xcbutilwm
          xwayland
        ];
      in
        rec {
        # `nix develop`
        devShell = pkgs.mkShell {
          inherit buildInputs;
        };
      });
}
