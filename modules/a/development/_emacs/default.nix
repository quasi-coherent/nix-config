_: let
  perSystem = {inputs', ...}: let
    latestEmacsForDaniel = import ./pkgsFor.nix {epkgs = latestEpkgs;};
    latestEpkgs = inputs'.emacs-overlay.packages.emacs-git.pkgs;
    stableEmacsForDaniel = import ./pkgsFor.nix {epkgs = stableEpkgs;};
    stableEpkgs = inputs'.emacs-overlay.packages.emacs-unstable.pkgs;
  in {
    packages = {
      inherit latestEmacsForDaniel stableEmacsForDaniel;
    };
  };
in {
  inherit perSystem;
}
