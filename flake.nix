{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      # Note the `.pkgsStatic`, which produces a static executable
      let pkgs = ((import nixpkgs) { inherit system; }).pkgsStatic;

      # Based on https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/rust.section.md
      in {
        defaultPackage = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
          pname = "addr2line-rs";
          version = "2025-05-21-b7dcf5f";

          buildFeatures = [ "bin" ];
          doCheck = false;

          src = pkgs.fetchFromGitHub {
            owner = "gimli-rs";
            repo = "addr2line";
            rev = "b7dcf5fff6908cd31ab9d10b2ed95f5bf890dca1";
            hash = "sha256-u6UKqB85vVGiu8v3sCpVsmnZn9T53aEq4QGc7ORLCaQ=";
          };

          cargoHash = "sha256-vx2WiqI356PBNiSv2IyGWgo3fKFO8w4Gx7cJzrXtetQ=";
        });

        # For `nix develop` (optional, can be skipped):
        devShell =
          pkgs.mkShell { nativeBuildInputs = with pkgs; [ rustc cargo ]; };
      });
}
