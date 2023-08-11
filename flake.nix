{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      # inputs.unstable.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, hyprland }@inputs:
    let
      # localOverlay = self: super: {
      #   inherit ayu-light-bat;
      # };

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

      buildInputs = with pkgs; [
        rnix-lsp
        lua-language-server
      ];

      system = "x86_64-linux";
      system_darwin = "x86_64-darwin";
    in
    {
      homeConfigurations = {
        pepijn = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            hyprland.homeManagerModules.default
            ./home_linux.nix
            { wayland.windowManager.hyprland.enable = true; }
          ];

        };
        #   pepijn_mac = home-manager.lib.homeManagerConfiguration {
        #     system = system_darwin;
        #     username = "poverbeeke";
        #     homeDirectory = "/Users/poverbeeke";
        #     stateVersion = "21.03";
        #     configuration = { config, pkgs, ayu-light-bat, ... }:
        #       {
        #         unstable.overlays = [
        #           localOverlay
        #         ];
        #         unstable.config = {
        #           allowUnfree = true;
        #           allowBroken = true;
        #         };
        #         imports = [
        #           ./home_mac.nix
        #         ];
        #       };
        #   };
      };
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./machine/configuration.nix
          ];
        };
      };

      devShells.${system}.default = pkgs.mkShell {
        inherit buildInputs;
      };
    };
}
