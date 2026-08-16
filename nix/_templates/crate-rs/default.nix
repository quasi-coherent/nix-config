{inputs, ...}: let
  perSystem = {
    lib,
    pkgs,
    inputs',
    self',
    ...
  }: let
    inherit (craneLib.crateNameFromCargoToml {inherit src;}) pname version;
    args = {
      inherit src;
      strictDeps = true;
    };
    cargoArtifacts = craneLib.buildDepsOnly args;
    craneLib = (inputs.crane.mkLib pkgs).overrideToolchain rust-stable.toolchain;
    eg-rs = craneLib.buildPackage {
      inherit pname version cargoArtifacts;
      inherit (args) src strictDeps;
    };
    fmtt = pkgs.writeShellApplication {
      name = "fmtt";
      text = ''${lib.getExe self'.formatter} "$@"'';
    };
    rust-stable = inputs'.fenix.packages.stable;
    src = craneLib.cleanCargoSource ./.;
  in {
    checks = {
      lint = craneLib.cargoClippy {
        inherit cargoArtifacts pname version;
        inherit (args) src strictDeps;
        cargoClippyExtraArgs = "--keep-going -- -Dwarnings";
      };
    };
    devShells.default = craneLib.devShell {
      RUST_SRC_PATH = "${rust-stable.rust-src}/lib/rustlib/src/rust/library";
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
    };
    packages = {
      inherit eg-rs;
      target = cargoArtifacts;
    };
    treefmt = {
      programs = {
        nixfmt.enable = true;
        rustfmt.enable = true;
        taplo.enable = true;
        typos.enable = true;
      };
      projectRootFile = ".git/config";
      settings.excludes = [".direnv/*"];
    };
  };
in {
  inherit perSystem;
  imports = [inputs.treefmt-nix.flakeModule];
}
