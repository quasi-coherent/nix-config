{ lib, ... }:
let
  homeWithEmacsPackage =
    { emacs, pkgs }:
    {
      home = {
        packages = [
          emacs
          pkgs.emacs-lsp-booster
          pkgs.coreutils-prefixed # For `--dired` if on darwin
        ];
        sessionVariables =
          let
            editor = lib.getBin (pkgs.writeShellScript "editor" ''exec emacsclient -nw -c -a "" "$@"'');
          in
          {
            EDITOR = "${editor}";
            VISUAL = "${editor}";
          };
      };
      programs.zsh = {
        siteFunctions.e = ''emacsclient -nw -q -u -c -a "" "''${@:-.}"'';
        shellAliases.ekill = "pkill emacs";
      };
    };
in
{
  imports = [ ./_emacs ];

  our.nix-config.provides = {
    stable-emacs.homeManager =
      { pkgs, self', ... }:
      homeWithEmacsPackage {
        inherit pkgs;
        emacs = self'.packages.stableEmacsForDaniel;
      };

    latest-emacs.homeManager =
      { pkgs, self', ... }:
      homeWithEmacsPackage {
        inherit pkgs;
        emacs = self'.packages.latestEmacsForDaniel;
      };
  };
}
