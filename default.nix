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
  hello-agda         = pkgs.callPackage ./agda    {};

  hello-cplusplus_5  = pkgs.callPackage ./c++     { packages = "llvmPackages_5"; };
  hello-cplusplus_6  = pkgs.callPackage ./c++     { packages = "llvmPackages_6"; };
  hello-cplusplus_7  = pkgs.callPackage ./c++     { packages = "llvmPackages_7"; };
  hello-cplusplus_8  = pkgs.callPackage ./c++     { packages = "llvmPackages_8"; };
  hello-cplusplus_9  = pkgs.callPackage ./c++     { packages = "llvmPackages_9"; };
  # jww (2020-03-03): Dies with: Cannot find llvmPackages_10
  # hello-cplusplus_10 = pkgs.callPackage ./c++     { packages = "llvmPackages_10"; };

  hello-coq_8_7       = pkgs.callPackage ./coq     { packages = "coqPackages_8_7"; };
  hello-coq_8_8       = pkgs.callPackage ./coq     { packages = "coqPackages_8_8"; };
  hello-coq_8_9       = pkgs.callPackage ./coq     { packages = "coqPackages_8_9"; };
  hello-coq_8_10      = pkgs.callPackage ./coq     { packages = "coqPackages_8_10"; };
  hello-coq_8_11      = pkgs.callPackage ./coq     { packages = "coqPackages_8_11"; };

  hello-haskell_844   = (pkgs.callPackage ./haskell { compiler = "ghc844"; })
    .overrideAttrs(_: { name = "haskell-ghc844-hello-1.0.0"; });
  hello-haskell_86    = (pkgs.callPackage ./haskell { compiler = "ghc865"; })
    .overrideAttrs(_: { name = "haskell-ghc865-hello-1.0.0"; });
  hello-haskell_882   = (pkgs.callPackage ./haskell { compiler = "ghc882"; })
    .overrideAttrs(_: { name = "haskell-ghc882-hello-1.0.0"; });
  # jww (2020-03-03): Fails building several dependencies.
  # hello-haskell_8101 = pkgs.callPackage ./haskell { compiler = "ghc8101"; };

  hello-python_2      = pkgs.callPackage ./python  { packages = "python2Packages"; };
  hello-python_3      = pkgs.callPackage ./python  { packages = "python3Packages"; };

  hello-rust_1_38_0   = pkgs.callPackage ./rust    { packages = "rustPackages_1_38_0"; };
  hello-rust_1_41_0   = pkgs.callPackage ./rust    { packages = "rustPackages_1_41_0"; };

  hello-golang        = (pkgs.callPackage ./golang  { packages = "buildGo113Package"; })
    .overrideAttrs(_: { name = "golang-1.13-hello-1.0.0"; });

  hello-scala_2_10    = pkgs.callPackage ./scala   { compiler = "scala_2_10"; };
  hello-scala_2_11    = pkgs.callPackage ./scala   { compiler = "scala_2_11"; };
  hello-scala_2_12    = pkgs.callPackage ./scala   { compiler = "scala_2_12"; };
  hello-scala_2_13    = pkgs.callPackage ./scala   { compiler = "scala_2_13"; };

  hello-common_lisp   = pkgs.callPackage ./lisp    { compiler = "sbcl"; };

  hello-emacs_lisp_25 = pkgs.callPackage ./emacs   { packages = "emacs25Packages"; };
  hello-emacs_lisp_26 = pkgs.callPackage ./emacs   { packages = "emacs26Packages"; };

  hello-ruby_2_5      = pkgs.callPackage ./ruby    { compiler = "ruby_2_5"; };
  hello-ruby_2_6      = pkgs.callPackage ./ruby    { compiler = "ruby_2_6"; };
  hello-ruby_2_7      = pkgs.callPackage ./ruby    { compiler = "ruby_2_7"; };
}
