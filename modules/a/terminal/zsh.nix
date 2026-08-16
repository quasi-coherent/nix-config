{a, ...}: {
  a.zsh.homeManager = {config, ...}: {
    programs.zsh = {
      autosuggestion = {
        enable = true;

        strategy = [
          "history"
          "completion"
        ];
      };

      defaultKeymap = "emacs";
      dotDir = "${config.xdg.configHome}/zsh";
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;

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

      historySubstringSearch = {
        enable = true;
        searchDownKey = "^N";
        searchUpKey = "^P";
      };

      initContent = ''
        autoload -U select-word-style
        select-word-style bash
      '';

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
        md = "mkdir -p";
        rd = "rmdir";
      };

      shellGlobalAliases = {
        "..." = "../..";
        "...." = "../../..";
        "....." = "../../../..";
        "......" = "../../../../..";
      };

      syntaxHighlighting.enable = true;
    };
  };

  our.nix-config.includes = [a.zsh];
}
