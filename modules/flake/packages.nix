{ den, ... }:
let
  perSystem =
    { pkgs, self', ... }:
    let
      # Responsible for e.g. `user@hostname switch` to alias darwin-rebuild
      # commands for convenience.
      activatePkgs = den.lib.nh.denPackages { fromFlake = true; } pkgs;

      fmtt = self'.formatter;
    in
    {
      packages = activatePkgs // {
        inherit (pkgs) nix-fast-build;
        inherit fmtt;
      };

      nix-config = [
        "nixpkgs"
        "emacs-overlay"
        "fenix"
      ];
    };
in
{
  inherit perSystem;
}
