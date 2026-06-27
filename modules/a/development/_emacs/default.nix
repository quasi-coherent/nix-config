{ ... }:
let
  flake-file.inputs = {
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  perSystem =
    { inputs', ... }:
    let
      latestEpkgs = inputs'.emacs-overlay.packages.emacs-git.pkgs;
      stableEpkgs = inputs'.emacs-overlay.packages.emacs-unstable.pkgs;
      latestEmacsForDaniel = import ./pkgsFor.nix { epkgs = latestEpkgs; };
      stableEmacsForDaniel = import ./pkgsFor.nix { epkgs = stableEpkgs; };
    in
    {
      packages = {
        inherit latestEmacsForDaniel stableEmacsForDaniel;
      };
    };
in
{
  inherit flake-file perSystem;
}
