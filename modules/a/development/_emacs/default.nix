{ ... }:
let
  flake-file.inputs = {
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  perSystem =
    { inputs', pkgs, ... }:
    let
      # Something complicated isn't working; the fix is an override to disable
      # a check that uses a symbol incorrectly and causes the build to fail for
      # using unrecognized types/values (bool, true and false); see:
      #
      # https://github.com/nix-community/emacs-overlay/pull/520
      disableC23Darwin =
        emacs:
        emacs.overrideAttrs (old: {
          configureFlags =
            old.configureFlags ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ "ac_cv_prog_cc_c23=no" ];
        });
      latestEpkgs = pkgs.emacsPackagesFor (disableC23Darwin inputs'.emacs-overlay.packages.emacs-git);
      stableEpkgs = pkgs.emacsPackagesFor (
        disableC23Darwin inputs'.emacs-overlay.packages.emacs-unstable
      );
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
