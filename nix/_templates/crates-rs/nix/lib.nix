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
        rustTools = inputs'.fenix.packages.default;
        crane = crane'.overrideToolchain rustTools.toolchain;

        src = crane.cleanCargoSource root;

        # The root crate name and version.
        crateName =
          {
            crate ? root,
          }:
          crane.crateNameFromCargoToml { src = crane.cleanCargoSource crate; };

        # Build just dependencies for the cache.
        cargoArtifacts =
          let
            # The smallest possible fileset that can build the workspace deps:
            cargoTomlAndLock = crane.fileset.cargoTomlAndLock root;
          in
          crane.buildDepsOnly {
            inherit (crateName { }) pname version;
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
              (crane.fileset.commonCargoSources crate)
            ];
          };

        mkCratePackage =
          crate:
          let
            inherit (crateName { inherit crate; }) pname version;
          in
          crane.buildPackage {
            inherit cargoArtifacts pname version;
            src = filesetForCrate crate;
            strictDeps = true;
            cargoBuildExtraArgs = "--all-features -p ${pname}";
          };
      };
    };
}
