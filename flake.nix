{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }@inputs:
    let
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      system = "x86_64-linux";
    in
    {
      homeConfigurations = {
        pepijn = home-manager.lib.homeManagerConfiguration {
          inherit system;
          username = "pepijn";
          homeDirectory = "/home/pepijn";
          stateVersion = "21.03";
          configuration = { config, pkgs, ... }:
            {
              nixpkgs.config = {
                allowUnfree = true;
              };
              imports = [
                ./home_linux.nix
              ];
            };

        };
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
    };
}
