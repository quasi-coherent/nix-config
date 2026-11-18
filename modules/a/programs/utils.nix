{ a, ... }:
{
  # Command line utilities.
  a.programs.utils.homeManager =
    { lib, pkgs, ... }:
    {
      home.packages = with pkgs; [
        calc
        coreutils-prefixed
        duf
        dust
        moreutils
        procs
        sd
      ];

      programs = {
        bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [
            batdiff
            batgrep
            batwatch
          ];
        };

        btop.enable = true;

        devenv = {
          enable = true;
          enableZshIntegration = true;
        };

        direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
          silent = true;
        };

        eza = {
          enable = true;
          enableZshIntegration = true;
        };

        fastfetch.enable = true;
        fd.enable = true;

        fzf = {
          changeDirWidget.command = "fd -t d";
          defaultCommand = "fd -t f";
          defaultOptions = [
            "--height 40%"
            "--border"
          ];
          enable = true;
          enableZshIntegration = true;
          fileWidget.command = "fd -t f";
          historyWidget.options = [
            "--sort"
            "--exact"
          ];
        };

        nix-your-shell = {
          enable = true;
          enableZshIntegration = true;
          nix-output-monitor.enable = true;
        };

        nnn = {
          enable = true;
          enableZshIntegration = true;
          options = {
            A = true;
            Q = true;
            c = true;
            r = true;
            t = 8;
          };
          plugins.mappings =
            lib.optionalAttrs pkgs.stdenvNoCC.hostPlatform.isDarwin {
              w = "cbcopy-mac";
              y = "cbpaste-mac";
            }
            // {
              F = "fzcd";
              L = "launch";
              N = "renamer";
              R = "fzhist";
              d = "diffs";
              g = "gitroot";
              j = "autojump";
              p = "preview-tabbed";
              s = "stats";
            };
          quitcd = true;
        };

        ripgrep = {
          arguments = [
            "--smart-case"
            "--hidden"
            "--glob=!.git/"
            "--no-heading"
            "--color=auto"
            "--pcre2"
            "--line-number"
          ];

          enable = true;
        };

        ripgrep-all.enable = true;

        tealdeer = {
          enable = true;
          settings.updates.auto_update = true;
        };

        zoxide = {
          enable = true;
          enableZshIntegration = true;
        };

        zsh.shellAliases = rec {
          l = "eza";
          la = "eza -a";
          ll = "eza -lahomb --group --group-directories-first --color-scale=all --sort=modified";
          llg = "${ll} --git";
          ls = "eza";
          lsa = "${la}";
          tree = "eza --tree --git-ignore";
        };
      };
    };

  our.nix-config.includes = [ a.programs.utils ];
}
