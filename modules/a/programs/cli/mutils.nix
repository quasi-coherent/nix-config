{ a, ... }:
{
  our.nix-config.includes = [ a.mutils ];

  # Miscellaneous CLI utils.
  # Mostly the "rewrite <unix tool that's been around since 1978> in Rust" kind.
  a.mutils.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        calc
        coreutils-prefixed
        curl
        curlie
        doggo
        duf
        dust
        httpie
        just
        jless
        moreutils
        procs
        scc
        sd
        stockfish
        wget
        yq
      ];

      programs.bat.enable = true;
      programs.btop.enable = true;
      programs.eza.enable = true;
      programs.fastfetch.enable = true;
      programs.fd.enable = true;
      programs.feh.enable = true;
      programs.fzf.enable = true;
      programs.jq.enable = true;
      programs.ripgrep.enable = true;
      programs.tealdeer.enable = true;

      programs.bat.extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        batwatch
      ];

      programs.eza.enableZshIntegration = true;

      programs.fzf = {
        enableZshIntegration = true;
        defaultCommand = "fd -t f";
        defaultOptions = [
          "--height 40%"
          "--border"
        ];
        fileWidgetCommand = "fd -t f";
        historyWidgetOptions = [
          "--sort"
          "--exact"
        ];
        changeDirWidgetCommand = "fd -t d";
      };

      programs.tealdeer.settings.updates.auto_update = true;

      programs.zsh.shellAliases = rec {
        l = "eza";
        ls = "eza";
        la = "eza -a";
        lsa = "${la}";
        ll = "eza -lahomb --group --group-directories-first --color-scale=all --sort=modified";
        llg = "${ll} --git";
        tree = "eza --tree";
      };
    };
}
