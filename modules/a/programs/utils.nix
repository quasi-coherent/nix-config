{ a, ... }:
{
  # Command line utilities.
  a.programs.utils.homeManager =
    { pkgs, ... }:
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
          enable = true;
          enableZshIntegration = true;
          defaultCommand = "fd -t f";
          defaultOptions = [
            "--height 40%"
            "--border"
          ];
          changeDirWidget.command = "fd -t d";
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

        # television = {
        #   enable = true;
        #   enableZshIntegration = true;
        # };

        yazi = {
          enable = true;
          enableZshIntegration = true;
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
