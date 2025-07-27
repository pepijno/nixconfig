{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
    neovim-nightly-overlay.url =
      "github:nix-community/neovim-nightly-overlay/5c2f79eef3dbe9522b6e79fb7f1d99dd593e478a";
    wrapper-manager.url = "github:viperML/wrapper-manager";
  };

  outputs = { self, nixpkgs-unstable, nixpkgs, home-manager, ... }@inputs:
    let
      allowed-unfree-packages = [
        "vivaldi"
        "vivaldi-ffmpeg-codecs"
        "steam"
        "steam-original"
        "steam-run"
        "steam-unwrapped"
        "widevine-cdm"
        "discord"
      ];
      overlay-nixpkgs = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
            allowNonfree = true;
            allowUnfreePredicate = (pkg: true);
          };
        };
      };
      pkgs = import nixpkgs {
        config = {
          allowUnfree = true;
          allowNonfree = true;
          allowUnfreePredicate = (pkg: true);
        };
        overlays = [ overlay-nixpkgs ];
        inherit system;
      };

      buildInputs = with pkgs; [
        nixd
        nixfmt-classic
        lua-language-server
        stylua
        fish-lsp
        xorg.libX11
        xorg.libXinerama
        xorg.libXft
        gcc
        gnumake
      ];

      runtimeRoot = builtins.getEnv "PWD";

      mkSymlinkAttrs = config: import ./lib/mkSymlinkAttrs.nix {
        inherit pkgs;
        runtimeRoot = builtins.getEnv "PWD";
        context = self;
        hm = config.lib;
      };

      system = "x86_64-linux";
    in {
      homeConfigurations = {
        pepijn = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            inherit allowed-unfree-packages;
            inherit mkSymlinkAttrs;
          };
          modules = [ ./home_linux.nix ];
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
