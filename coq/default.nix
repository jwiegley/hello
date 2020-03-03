{ packages ? "coqPackages_8_11"

, rev      ? "1fe82110febdf005d97b2927610ee854a38a8f26"
, sha256   ? "08x6saa7iljyq2m0j6p9phy0v17r3p8l7vklv7y7gvhdc7a85ppi"

, pkgs     ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256; }) {
    config.allowUnfree = true;
    config.allowBroken = false;
    overlays = [
      (self: super:
       let
         nixpkgs = { rev, sha256 }:
           import (super.fetchFromGitHub {
             owner = "NixOS";
             repo  = "nixpkgs";
             inherit rev sha256;
           }) { config.allowUnfree = true; };

         known-good-20191113_070954 = nixpkgs {
           rev    = "620124b130c9e678b9fe9dd4a98750968b1f749a";
           sha256 = "0xgy2rn2pxii3axa0d9y4s25lsq7d9ykq30gvg2nzgmdkmy375rr";
         };
       in
       {
         inherit (known-good-20191113_070954) shared-mime-info;
       })
    ];
  }
}:

with pkgs.${packages};

pkgs.stdenv.mkDerivation rec {
  name = "coq${coq.coq-version}-hello-${version}";
  version = "1.0";

  src =
    if pkgs ? coqFilterSource
    then pkgs.coqFilterSource [] ./.
    else ./.;

  buildInputs = [
    coq coq.ocaml coq.camlp5 coq.findlib
  ];
  enableParallelBuilding = true;

  buildPhase = ''
    coq_makefile -f _CoqProject -o Makefile.coq
    make -f Makefile.coq JOBS=$NIX_BUILD_CORES
  '';
  installFlags = "COQLIB=$(out)/lib/coq/${coq.coq-version}/";

  env = pkgs.buildEnv { name = name; paths = buildInputs; };
  passthru = {
    compatibleCoqVersions = v:
      builtins.elem v [ "8.6" "8.7" "8.8" "8.9" "8.10" "8.11" ];
 };
}
