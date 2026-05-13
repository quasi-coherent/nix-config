{ ... }:
let
  perSystem =
    {
      mkCratePackage,
      ...
    }:
    let
      facade-rs = mkCratePackage "facade-rs";
      other-rs = mkCratePackage "other-rs";
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
