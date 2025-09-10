{
  description = "System config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay/";
    wrapper-manager.url = "github:viperML/wrapper-manager";
  };

  outputs = { self, nixpkgs-unstable, nixpkgs, home-manager, ... }@inputs:
    let
      systems = [ "x86_64-linux" "aarch64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

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

      mkPkgs = system:
        let
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
        in import nixpkgs-unstable {
          inherit system;
          config = {
            allowUnfree = true;
            allowNonfree = true;
            allowUnfreePredicate = (pkg: true);
          };
          overlays = [ overlay-nixpkgs ];
        };

      mkBuildInputs = system:
        let pkgs = mkPkgs system;
        in with pkgs;
        [ nixd nixfmt-classic lua-language-server stylua fish-lsp ]
        ++ nixpkgs-unstable.lib.optionals (system == "x86_64-linux") [
          # X11 dependencies only for Linux
          # dwm
          xorg.libX11
          xorg.libXinerama
          xorg.libXft
          gcc
          gnumake
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
          xorg.xcbutilwm
          xwayland
        ];

      mkSymlinkAttrs = system: config:
        let pkgs = mkPkgs system;
        in import ./lib/mkSymlinkAttrs.nix {
          inherit pkgs;
          runtimeRoot = builtins.getEnv "PWD";
          context = self;
          hm = config.lib;
        };

    in {
      homeConfigurations = {
        pepijn = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "x86_64-linux";
          extraSpecialArgs = {
            inherit inputs;
            inherit allowed-unfree-packages;
            mkSymlinkAttrs = mkSymlinkAttrs "x86_64-linux";
          };
          modules = [ ./home_linux.nix ];
        };
        pepijn_mac = home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "aarch64-darwin";
          extraSpecialArgs = {
            inherit inputs;
            inherit allowed-unfree-packages;
            mkSymlinkAttrs = mkSymlinkAttrs "aarch64-darwin";
          };
          modules = [ ./home_mac.nix ];
        };
      };
      nixosConfigurations = {
        desktop = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./machine/configuration.nix ];
        };
      };

      devShells = forAllSystems (system: {
        default =
          (mkPkgs system).mkShell { buildInputs = mkBuildInputs system; };
      });
    };
}
