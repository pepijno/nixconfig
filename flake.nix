{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      # inputs.unstable.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager }@inputs:
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
        nixfmt
      ];

      system = "x86_64-linux";
      system_darwin = "x86_64-darwin";
    in
    {
      homeConfigurations = {
        pepijn = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home_linux.nix
          ];
          # inherit system;
          # inherit pkgs;
          # username = "pepijn";
          # homeDirectory = "/home/pepijn";
          # stateVersion = "21.03";
          # configuration = { config, pkgs, ayu-light-bat, ... }:
          #   {
          #     # unstable.overlays = [
          #     #   localOverlay
          #     #   nixgl.overlay
          #     # ];
          #     # unstable.config = {
          #     #   allowUnfree = true;
          #     #   allowNonfree = true;
          #     #   allowUnfreePredicate = (pkg: true);
          #     # };
          #     imports = [
          #       ./home_linux.nix
          #     ];
          #   };

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
          specialArgs = inputs;
          modules = [
            ./machine/configuration.nix
          ];
        };
      };
      # pepijn = self.homeConfigurations.pepijn.activationPackage;

      devShells.${system}.default = pkgs.mkShell {
        inherit buildInputs;
      };
    };
}
