with import <nixpkgs> {};

{ ... }:

stdenv.mkDerivation {
  pname = "sway-launcher-desktop";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Biont";
    repo = "sway-launcher-desktop";
    rev = "c741cb2dcd60b84e3f3ca8eeb7a9a64ad14b26d1";
    sha256 = "0blnlilk9lwx6asyx6ni7rrx4fm8g54qznpyfba6qwrp7h38aycx";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv sway-launcher-desktop.sh $out/bin/sway-launcher
  '';
}
