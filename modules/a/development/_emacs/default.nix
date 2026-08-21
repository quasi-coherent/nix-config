_:
let
  perSystem =
    { inputs', ... }:
    let
      latestEmacsForMyNeeds = import ./pkgsFor.nix { epkgs = latestEpkgs; };
      latestEpkgs = inputs'.emacs-overlay.packages.emacs-git.pkgs;
      stableEmacsForMyNeeds = import ./pkgsFor.nix { epkgs = stableEpkgs; };
      stableEpkgs = inputs'.emacs-overlay.packages.emacs-unstable.pkgs;
    in
    {
      packages = {
        inherit latestEmacsForMyNeeds stableEmacsForMyNeeds;
      };
    };
in
{
  inherit perSystem;
}
