{ a, lib, ... }:
{
  imports = [ ./_emacs ];

  our.nix-config.includes = [ a.emacs ];

  a.emacs.homeManager =
    {
      pkgs,
      self',
      ...
    }:
    let
      emacs = self'.packages.emacsForDaniel;
    in
    {
      home.packages = [
        emacs
        pkgs.emacs-lsp-booster
      ];

      ## TODO: This crashes on occasion with some inscrutible error about treesitter.
      # launchd.agents.emacs = {
      #   enable = true;
      #   config = {
      #     Label = "org.${config.home.username}.emacs";
      #     ProgramArguments = [
      #       "${pkgs.runtimeShell}"
      #       "-l"
      #       "-c"
      #       "${emacsPkg}/bin/emacs --fg-daemon"
      #     ];
      #     ProcessType = "Interactive";
      #     RunAtLoad = true;
      #     KeepAlive = {
      #       Crashed = true;
      #       SuccessfulExit = false;
      #     };
      #   };
      # };

      programs.zsh = {
        siteFunctions.e = ''emacsclient -nw -q -u -c -a "" "''${@:-.}"'';
        shellAliases.ekill = "pkill emacs";
      };

      home.sessionVariables =
        let
          editor = lib.getBin (pkgs.writeShellScript "editor" ''exec emacsclient -nw -c -a "" "$@"'');
        in
        {
          EDITOR = "${editor}";
          VISUAL = "${editor}";
        };
    };
}
