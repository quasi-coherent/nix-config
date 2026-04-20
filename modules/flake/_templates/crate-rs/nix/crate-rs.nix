{ inputs, ... }:
{
  perSystem = { inputs', pkgs, ... }:
  let
    fenixPkgs = inputs'.fenix.packages;

    toolchain =
      with fenixPkgs.default; fenixPkgs.combine [
        rustc
        cargo
        clippy
        rustfmt
        rust-src
        rust-analyzer
      ];

    craneLib = (inputs.crane.mkLib pkgs).overrideToolchain toolchain;

    src = craneLib.cleanCargoSource ../.;

    args = {
      inherit src;
      strictDeps = true;
    };

    cargoArtifacts = craneLib.buildDepsOnly args;

    crateName = craneLib.crateNameFromCargoToml { inherit src; };

    crate-rs = craneLib.buildPackage {
      inherit (crateName) pname version;
      inherit (args) src strictDeps;
      inherit cargoArtifacts;
    };
  in
    {
      packages = {
        inherit crate-rs;
        default = crate-rs;
        deps-only = cargoArtifacts;
      };

      devShells.default = pkgs.mkShell {
        inputsFrom = [ crate-rs ];
        packages = [ toolchain ];
        RUST_SRC_PATH = "${fenixPkgs.default.rust-src}/lib/rustlib/src/rust/library";
      };
    };
}
