{ inputs, ... }:
let
  perSystem =
    {
      self',
      inputs',
      lib,
      pkgs,
      ...
    }:
    let
      rust-stable = inputs'.fenix.packages.stable;
      craneLib = (inputs.crane.mkLib pkgs).overrideToolchain rust-stable.toolchain;
      src = craneLib.cleanCargoSource ../.;

      inherit (craneLib.crateNameFromCargoToml { inherit src; }) pname version;

      args = {
        inherit src;
        strictDeps = true;
      };

      cargoArtifacts = craneLib.buildDepsOnly args;

      crate-rs = craneLib.buildPackage {
        inherit pname version cargoArtifacts;
        inherit (args) src strictDeps;
      };

      fmtt = pkgs.writeShellApplication {
        name = "fmtt";
        text = ''${lib.getExe self'.formatter} "$@"'';
      };
    in
    {
      packages = {
        inherit crate-rs;
        default = crate-rs;
        target = cargoArtifacts;
      };

      devShells.default = craneLib.mkShell {
        inputsFrom = [ crate-rs ];
        packages = [
          fmtt
          pkgs.cachix
          rust-stable.toolchain
        ];
        RUST_SRC_PATH = "${rust-stable.rust-src}/lib/rustlib/src/rust/library";
      };
    };
in
{
  inherit perSystem;

  imports = [
    inputs.treefmt-nix.flakeModule
    ./treefmt.nix
  ];
}
