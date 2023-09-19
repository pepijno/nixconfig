{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      # inputs.unstable.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, hyprland, ... }@inputs:
    let
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
          extraSpecialArgs = { inherit inputs; };
          modules = [
            hyprland.homeManagerModules.default
            ./home_linux.nix
            { wayland.windowManager.hyprland.enable = true; }
          ];
        };
        pepijn_mac = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = system_darwin; };
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./home_mac.nix
          ];
        };
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
