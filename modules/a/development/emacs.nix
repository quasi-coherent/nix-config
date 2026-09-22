{ lib, ... }:
let
  homeWithEmacsPackage =
    {
      pkgs,
      emacs,
    }:
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
        shellAliases.ekill = "pkill emacs";
        siteFunctions.e = ''emacsclient -nw -q -u -c -a "" "''${@:-.}"'';
      };

      xdg.configFile.emacs = {
        recursive = true;
        source = ./_files/emacs;
      };
    };
in
{
  imports = [ ./_emacs ];

  our.nix-config.provides = {
    latest-emacs.homeManager =
      {
        pkgs,
        self',
        ...
      }:
      homeWithEmacsPackage {
        inherit pkgs;
        emacs = self'.packages.latestEmacsForMyNeeds;
      };

    stable-emacs.homeManager =
      {
        pkgs,
        self',
        ...
      }:
      homeWithEmacsPackage {
        inherit pkgs;
        emacs = self'.packages.stableEmacsForMyNeeds;
      };
  };
}
