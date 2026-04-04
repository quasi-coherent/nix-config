{ a, ... }:
{
  our.nix-config.includes = [ a.zsh ];

  a.zsh.homeManager =
    { config, ... }:
    {
      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
        defaultKeymap = "emacs";
        setOptions = [
          "ALWAYS_TO_END"
          "AUTO_CD"
          "AUTO_PUSHD"
          "CDABLE_VARS"
          "CD_SILENT"
          "COMPLETE_IN_WORD"
          "INTERACTIVE_COMMENTS"
          "NO_BEEP"
          # You would think that NO_BEEP means "no beeping in any situation" but
          # you would be wrong.
          "NO_HIST_BEEP"
          "NO_LIST_BEEP"
          "NO_PROMPT_BANG"
          "PUSHD_IGNORE_DUPS"
          "PUSHD_SILENT"
        ];
        initContent = ''
          autoload -U select-word-style
          select-word-style bash
        '';
        history = {
          append = true;
          expireDuplicatesFirst = true;
          extended = true;
          findNoDups = true;
          ignoreDups = true;
          ignoreSpace = true;
          share = true;
          size = 100000;
        };
        autosuggestion.enable = true;
        autosuggestion.strategy = [
          "history"
          "completion"
        ];
        enableCompletion = true;
        enableVteIntegration = true;
        syntaxHighlighting.enable = true;
        historySubstringSearch.enable = true;
        historySubstringSearch.searchDownKey = "^N";
        historySubstringSearch.searchUpKey = "^P";
        dirHashes = {
          cfg = "${config.home.homeDirectory}/nix-config";
          d = "${config.home.homeDirectory}/d";
        };
        shellGlobalAliases = {
          "..." = "../..";
          "...." = "../../..";
          "....." = "../../../..";
          "......" = "../../../../..";
        };
        shellAliases = {
          "-" = "cd -";
          "1" = "cd -1";
          "2" = "cd -2";
          "3" = "cd -3";
          "4" = "cd -4";
          "5" = "cd -5";
          "6" = "cd -6";
          "7" = "cd -7";
          "8" = "cd -8";
          "9" = "cd -9";
          cdc = "cd ~cfg";
          cdd = "cd ~d";
          md = "mkdir -p";
          rd = "rmdir";
        };
      };
    };
}
