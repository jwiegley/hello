{ rev      ? "1fe82110febdf005d97b2927610ee854a38a8f26"
, sha256   ? "08x6saa7iljyq2m0j6p9phy0v17r3p8l7vklv7y7gvhdc7a85ppi"

, pkgs     ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256; }) {
    config.allowUnfree = true;
    config.allowBroken = false;
    overlays = [
    ];
  }
}:

{
  hello-agda      = pkgs.callPackage ./agda {};
  hello-cplusplus = pkgs.callPackage ./c++ {};
  hello-coq       = pkgs.callPackage ./coq {};
  hello-haskell   = pkgs.callPackage ./haskell {};
  hello-python    = pkgs.callPackage ./python {};
  hello-rust      = pkgs.callPackage ./rust {};
}
