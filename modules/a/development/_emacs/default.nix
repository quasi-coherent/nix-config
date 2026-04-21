{ inputs, ... }:
let
  flake-file.inputs = {
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  perSystem =
    { pkgs, ... }:
    let
      system = pkgs.stdenvNoCC.hostPlatform.system;
      latestEpkgs = inputs.emacs-overlay.packages.${system}.emacs-git-pgtk.pkgs;
      stableEpkgs = inputs.emacs-overlay.packages.${system}.emacs-unstable-pgtk.pkgs;
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
