{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { nixpkgs-unstable, nixpkgs, home-manager, ... }@inputs:
    let
      allowed-unfree-packages = [
        "vivaldi"
        "vivaldi-ffmpeg-codecs"
        "steam"
        "steam-original"
        "steam-run"
        "widevine-cdm"
        "discord"
      ];
      pkgs = import nixpkgs {
        config = {
          allowUnfree = true;
          allowNonfree = true;
          allowUnfreePredicate = (pkg: true);
        };
        overlays = [
          (final: prev: {
            dmenu = prev.dwm.overrideAttrs {
              src = ./dmenu;
            };
          })
        ];
        inherit system;
      };

      buildInputs = with pkgs; [
        nixd
        nixfmt
        lua-language-server
        stylua
        xorg.libX11
        xorg.libXinerama
        xorg.libXft
        gcc
        gnumake
      ];

      system = "x86_64-linux";
    in {
      homeConfigurations = {
        pepijn = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            inherit allowed-unfree-packages;
          };
          modules = [
            ./home_linux.nix
          ];
        };
        pepijn_mac = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home_mac.nix ];
        };
      };
      nixosConfigurations = {
        desktop = nixpkgs-unstable.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./machine/configuration.nix ];
        };
      };

      devShells.${system}.default = pkgs.mkShell { inherit buildInputs; };
    };
}
