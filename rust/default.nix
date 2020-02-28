{ packages ? "rustPackages_1_41_0"

, rev      ? "1fe82110febdf005d97b2927610ee854a38a8f26"
, sha256   ? "08x6saa7iljyq2m0j6p9phy0v17r3p8l7vklv7y7gvhdc7a85ppi"

, pkgs     ? import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
    inherit sha256; }) {
    config.allowUnfree = true;
    config.allowBroken = false;
    overlays = [
      (self: super: {})
    ];
  }
}:

with pkgs.${packages};

let
  rustdocs_script = pkgs.writeScript "rustdocs" ''
    doc=''${1:-std}
    file="${rustc.doc}/share/doc/rust/html/$doc/index.html"
    if [[ -f "$file" ]]; then
        exec ${pkgs.xdg_utils}/bin/xdg-open "$file"
    fi
    echo "$doc Rust documentation not found"
    exit 1
  '';

  rustdocs = pkgs.stdenv.mkDerivation rec {
    name = "${packages}-rustdocs";
    src = null;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp ${rustdocs_script} $out/bin/rustdocs
    '';
  };

in rustPlatform.buildRustPackage rec {
  pname = "hello";
  version = "1.0.0";

  src = ./.;

  cargoSha256 = "1nwk386lfj9prgp3mwnyxgjhk55vk0pcxndfrwlbcs14hixrskfg";

  cargoBuildFlags = [];

  buildInputs = [
    cargo rustfmt rustPlatform.rustcSrc rls rustdocs
  ];
  enableParallelBuilding = true;

  env = pkgs.buildEnv { name = pname; paths = buildInputs; };
}
