{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # inputs.unstable.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
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
        # overlays = [
        #   localOverlay
        #   nixgl.overlay
        # ];
        inherit system;
      };

      buildInputs = with pkgs; [ nixd nixfmt lua-language-server stylua ];

      system = "x86_64-linux";
      system_darwin = "x86_64-darwin";
    in {
      homeConfigurations = {
        pepijn = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            inherit allowed-unfree-packages;
          };
          modules = [
            hyprland.homeManagerModules.default
            ./home_linux.nix
            { wayland.windowManager.hyprland.enable = true; }
          ];
        };
        pepijn_mac = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home_mac.nix ];
        };
      };
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./machine/configuration.nix ];
        };
      };

      devShells.${system}.default = pkgs.mkShell { inherit buildInputs; };
    };
}
