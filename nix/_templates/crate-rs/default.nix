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
      src = craneLib.cleanCargoSource ./.;
      inherit (craneLib.crateNameFromCargoToml { inherit src; }) pname version;

      args = {
        inherit src;
        strictDeps = true;
      };

      cargoArtifacts = craneLib.buildDepsOnly args;

      eg-rs = craneLib.buildPackage {
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
        inherit eg-rs;
        target = cargoArtifacts;
      };

      checks = {
        lint = craneLib.cargoClippy {
          inherit cargoArtifacts pname version;
          inherit (args) src strictDeps;
          cargoClippyExtraArgs = "--keep-going -- -Dwarnings";
        };
      };

      treefmt = {
        projectRootFile = ".git/config";
        programs = {
          rustfmt.enable = true;
          nixfmt.enable = true;
          typos.enable = true;
          taplo.enable = true;
        };
        settings.excludes = [ ".direnv/*" ];
      };

      devShells.default = craneLib.devShell {
        packages = [
          fmtt
          pkgs.cargo-audit
          pkgs.cargo-expand
          pkgs.cargo-machete
          pkgs.cargo-sort-derives
          pkgs.cachix
          pkgs.just
          rust-stable.toolchain
        ];
        RUST_SRC_PATH = "${rust-stable.rust-src}/lib/rustlib/src/rust/library";
      };
    };
in
{
  inherit perSystem;
  imports = [ inputs.treefmt-nix.flakeModule ];
}
