{ compiler ? "ghc882"

, doBenchmark ? false
, doProfiling ? false
, doStrict    ? false

, rev    ? "1fe82110febdf005d97b2927610ee854a38a8f26"
, sha256 ? "08x6saa7iljyq2m0j6p9phy0v17r3p8l7vklv7y7gvhdc7a85ppi"

, pkgs ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256; }) {
    config.allowUnfree = true;
    config.allowBroken = false;
    overlays = [
      (self: super: {
         haskell = super.haskell // {
           packages = super.haskell.packages // {
             ${compiler} = super.haskell.packages.${compiler} // rec {
               ghc = super.haskell.packages.${compiler}.ghc //
                 { withPackages =
                     super.haskell.packages.${compiler}.ghc.withHoogle; };
               ghcWithPackages = ghc.withPackages;
             };
           };
         };
       })
    ];
  }

, mkDerivation ? null
}:

let haskellPackages = pkgs.haskell.packages.${compiler};

in haskellPackages.developPackage rec {
  name = "haskell-${compiler}-hello";
  root = ./.;

  modifier = drv: pkgs.haskell.lib.overrideCabal drv (attrs: {
    buildTools = (attrs.buildTools or []) ++ [
      haskellPackages.cabal-install
    ];

    enableLibraryProfiling = doProfiling;
    enableExecutableProfiling = doProfiling;

    testHaskellDepends = (attrs.testHaskellDepends or []) ++ [
      haskellPackages.criterion
    ];

    inherit doBenchmark;

    configureFlags =
      pkgs.lib.optional doStrict "--ghc-options=-Werror";

    passthru = {
      nixpkgs = pkgs;
      inherit haskellPackages;
    };
  });

  returnShellEnv = false;
}
