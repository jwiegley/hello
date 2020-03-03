{ packages ? "buildGo113Package"

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

pkgs.${packages} rec {
  pname = "hello-${version}";
  version = "1.0.0";

  goPackagePath = "github.com/jwiegley/hello";
  subPackages = [];

  src = ./.;

  # buildInputs = pkgs.stdenv.lib.optionals pkgs.stdenv.hostPlatform.isDarwin
  #   [ pkgs.CoreFoundation ];

  buildFlags = [ "--tags" "release" ];

  doCheck = true;
  checkPhase = ''
    cmp -b <(eval $(find . -name hello -type f -executable)) \
           <(echo "Hello, world!")
  '';

  env = pkgs.buildEnv { name = pname; paths = []; };
}
