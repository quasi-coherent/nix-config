_:
let
  perSystem =
    { inputs', ... }:
    {
      packages = {
        latestEmacsForMyNeeds = import ./pkgsFor.nix {
          epkgs = inputs'.emacs-overlay.packages.emacs-git.pkgs;
        };
        stableEmacsForMyNeeds = import ./pkgsFor.nix {
          epkgs = inputs'.emacs-overlay.packages.emacs-unstable.pkgs;
        };
      };
    };
in
{
  inherit perSystem;
}
