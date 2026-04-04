{ a, ... }:
{
  imports = [ ./_emacs ];

  our.nix-config.includes = [ a.emacs ];

  a.emacs.homeManager =
    {
      config,
      pkgs,
      self',
      ...
    }:
    let
      emacsPkg = self'.packages.emacsForDaniel;
    in
    {
      home.packages = [
        emacsPkg
        pkgs.emacs-lsp-booster
      ];

      launchd.agents.emacs = {
        enable = false;
        config = {
	  Label = "org.${config.home.username}.emacs";
          ProgramArguments = [
	    "${pkgs.runtimeShell}"
            "-l"
            "-c"
            "${emacsPkg}/bin/emacs --fg-daemon"
          ];
          ProcessType = "Interactive";
          RunAtLoad = true;
          KeepAlive = {
            Crashed = true;
            SuccessfulExit = false;
          };
        };
      };

      programs.zsh = {
        siteFunctions.e = ''emacsclient -nw -q -u -c -a "" "''${@:-.}"'';
        shellAliases.ekill = "pkill emacs";
      };

      home.sessionVariables = {
        EDITOR = ''emacs -nw -l "${config.xdg.configHome}/emacs/editor.el"'';
        VISUAL = ''emacs -nw -l "${config.xdg.configHome}/emacs/editor.el"'';
      };
    };
}
