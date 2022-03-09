# {
#   packageOverrides = pkgs: {
#     nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
#       inherit pkgs;
#     };
#   };
#   allowUnfree = true;
# }
let
  mozilla-overlays = fetchTarball {
    url = https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz;
  };
in
{
  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
  programs.home-manager.enable = true;
  home.stateVersion = "19.09";
  nixpkgs.config.allowUnfree = true;
  xdg.configFile."nixpkgs/config.nix".source = mozilla-overlays;
}
