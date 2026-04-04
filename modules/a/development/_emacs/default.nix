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
      ePkgs = inputs.emacs-overlay.packages.${system}.emacs-unstable-pgtk.pkgs;
    in
    {
      packages.emacsForDaniel = ePkgs.emacsWithPackages (import ./pkgsFor.nix);
    };
in
{
  inherit flake-file perSystem;
}
