{ inputs, ... }:
{
  perSystem = { self', inputs', pkgs, ... }:
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

    deps-only = craneLib.buildDepsOnly args;

    crate-rs = craneLib.buildPackage (args // {
      inherit deps-only;
    });
  in
    {
      packages = {
        inherit crate-rs deps-only;
        default = crate-rs;
      };

      checks = {
        inherit crate-rs;

        fmt = self'.formatter;
      };

      devShells.default = pkgs.mkShell {
        inputsFrom = [ crate-rs ];
        packages = [ toolchain ];
        RUST_SRC_PATH = "${fenixPkgs.default.rust-src}/lib/rustlib/src/rust/library";
      };
    };
}
