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
      emacsForDaniel = ePkgs.emacsWithPackages (import ./pkgsFor.nix);
    in
    {
      packages = {
        inherit emacsForDaniel;
        default = emacsForDaniel;
      };
    };
in
{
  inherit flake-file perSystem;
}
