{
  inputs = {
    fenix.url = "github:nix-community/fenix";
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem =
        { inputs', pkgs, ... }:
        let
          rust-stable = inputs'.fenix.packages.stable;
        in
        {
          devShells.default = pkgs.mkShell {
            packages = [ rust-stable.toolchain ];
            RUST_SRC_PATH = "${rust-stable.rust-src}/lib/rustlib/src/rust/library";
          };
        };
    };
}
