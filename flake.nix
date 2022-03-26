{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ayu-light-bat.url = "github:pepijno/ayu-light-bat";

    dmenu.url = "github:pepijno/dmenu";
  };

  outputs = { self, nixpkgs, home-manager, ayu-light-bat, dmenu }@inputs:
    let
      localOverlay = self: super: {
        inherit ayu-light-bat;
        dmenu = dmenu.defaultPackage.${system};
      };

      pkgs = import nixpkgs {
        inherit system;
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
          configuration = { config, pkgs, ayu-light-bat, ... }:
            {
              nixpkgs.overlays = [
                localOverlay
              ];
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
