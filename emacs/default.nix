{ packages ? "emacs26Packages"

, rev    ? "1fe82110febdf005d97b2927610ee854a38a8f26"
, sha256 ? "08x6saa7iljyq2m0j6p9phy0v17r3p8l7vklv7y7gvhdc7a85ppi"

, pkgs ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256; }) {
    config.allowUnfree = true;
    config.allowBroken = false;
    overlays = [
      (self: super: {})
    ];
  }
}:

pkgs.stdenv.mkDerivation rec {
  name = "${packages}-hello-${version}";
  version = "1.0.0";

  src = ./.;

  buildInputs = [ pkgs.${packages}.emacs ];

  enableParallelBuilding = true;

  buildPhase = ''
    sed -i -e 's%#!/usr/bin/env sbcl%#!${pkgs.${packages}.emacs}/bin/emacs%' hello.el
    chmod +x hello.el
  '';

  doCheck = true;
  checkPhase = ''
    cmp -b <(./hello.el) <(echo "Hello, world!")
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp hello.el $out/bin/hello
  '';
}
