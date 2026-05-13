{ ... }:
let
  perSystem =
    {
      mkCratePackage,
      ...
    }:
    let
      facade-rs = mkCratePackage ../.;
      other-rs = mkCratePackage ../crates/other-rs;
    in
    {
      packages = {
        inherit facade-rs other-rs;
      };
    };
in
{
  inherit perSystem;
}
