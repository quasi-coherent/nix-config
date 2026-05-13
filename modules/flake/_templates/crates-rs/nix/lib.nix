{ inputs, lib, ... }:
let
  root = ../.;
in
{
  perSystem =
    { pkgs, inputs', ... }:
    let
      crane' = inputs.crane.mkLib pkgs;
    in
    {
      _module.args = rec {
        # `default` is the nightly toolchain.
        crane = crane'.overrideToolchain inputs'.fenix.packages.default.toolchain;

        # The root crate name and version.
        manifest = crane.crateNameFromCargoToml { src = crane.cleanCargoSource root; };

        # Build just dependencies for the cache.
        cargoArtifacts =
          let
            # The smallest possible fileset that can build the workspace deps:
            cargoTomlAndLock = crane.fileset.cargoTomlAndLock root;
          in
          crane.buildDepsOnly {
            inherit (manifest) pname version;
            src = lib.fileset.toSource {
              inherit root;
              fileset = cargoTomlAndLock;
            };
            strictDeps = true;
          };

        filesetForCrate =
        crate:
        lib.fileset.toSource {
          inherit root;
          fileset = lib.fileset.union [
            ../Cargo.toml
            ../Cargo.lock
            ../crates/other-rs
          ];
        };

        mkCratePackage =
          pname:
          crane.buildPackage {
            inherit (manifest) version;
            inherit pname cargoArtifacts src;
            strictDeps = true;
            cargoBuildExtraArgs = "--all-features -p ${pname}";
          };
      };
    };
}
