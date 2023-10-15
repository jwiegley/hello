{ compiler ? "ghc8106"

, rev      ? "1fe82110febdf005d97b2927610ee854a38a8f26"
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

let
  haskellPackages = pkgs.haskell.packages.${compiler};

  # With thanks to Ryan Orendorff <ryan@orendorff.io> for providing the Agda
  # example.

  # The standard library in nixpkgs does not come with a *.agda-lib file, so
  # we generate it here.
  standard-library-agda-lib = pkgs.writeText "standard-library.agda-lib" ''
    name: standard-library
    include: ${pkgs.AgdaStdlib}/share/agda
  '';

  # Agda uses the AGDA_DIR environmental variable to determine where to load
  # default libraries from. This should have a few files in it, including the
  # "defaults" and "libraries" files generated below.
  #
  # More information (and possibilities!) are detailed here:
  # https://agda.readthedocs.io/en/v2.6.0.1/tools/package-system.html
  agdaDir = pkgs.stdenv.mkDerivation {
    name = "agdaDir";

    phases = [ "installPhase" ];

    # If you want to add more libraries simply list more in the $out/libraries
    # and $out/defaults folder.
    installPhase = ''
      mkdir $out
      echo "${standard-library-agda-lib}" >> $out/libraries
      echo "standard-library" >> $out/defaults
    '';
  };

in pkgs.stdenv.mkDerivation rec {
  name = "agda-${compiler}-hello-${version}";
  version = "1.0";

  src = ./.;

  buildInputs = [
    pkgs.AgdaStdlib agdaDir
  ] ++ (with haskellPackages; [
    Agda
    (ghcWithPackages (pkgs: [pkgs.ieee754]))
  ]);
  enableParallelBuilding = true;

  buildPhase = ''
    agda --compile --ghc-flag=-package --ghc-flag=ieee754 hello.agda
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp hello $out/bin
  '';

  env = pkgs.buildEnv { name = name; paths = buildInputs; };

  AGDA_DIR = agdaDir;
}
