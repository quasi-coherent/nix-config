{a, ...}: {
  a.vcs.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.difftastic];

    programs = {
      delta = {
        enable = true;
        enableGitIntegration = true;
        enableJujutsuIntegration = true;

        options = {
          line-numbers = true;
          side-by-side = false;
        };
      };

      git = {
        enable = true;

        ignores = [
          ".*"
          "!.gitignore"
          "!.gitkeep"
          "!.envrc"
          "!.sops.yaml"
          "!.dir-locals.el"
          "*.swp"
          "*.key"
          "target"
          "result"
          "out"
          "old"
        ];

        lfs.enable = true;

        settings = {
          diff.tool = "difftastic";

          difftool = {
            difftastic.cmd = "${pkgs.difftastic}/bin/difft $LOCAL $REMOTE";
            prompt = false;
          };

          init.defaultBranch = "master";
          pager.difftool = true;
          pull.rebase = true;

          push = {
            autoSetupRemote = true;
            default = "current";
          };
        };
      };

      jujutsu.enable = true;

      zsh = {
        shellAliases = {
          g = "git";
          ga = "git add";
          gaa = "git add --all";
          gb = "git branch";
          gbD = "git branch -D";
          gbd = "git branch -d";
          gc = "git commit --verbose";
          gcb = "git checkout -b";
          gclean = "git clean --interactive -d";
          gco = "git checkout";
          gconf = "git config";
          gconfls = "git config --list";
          gcount = "git shortlog --summary --numbered";
          gd = "git diff";
          gdc = "git diff --cached";
          gdn = "git rev-list --count --left-right @{upstream}..";
          gdup = "git diff @{upstream}";
          gg = "git grep";
          ggf = "git ls-files | grep";
          gl = "git pull --rebase";
          gla = "git pull --autostash";
          gllog = "git log --graph --all";
          glo = "git log --oneline --decorate";
          glog = "git log --graph";
          glogp = "git log --stat --patch";
          glon = "git --no-pager log -n";
          gp = "git push";
          gpF = "git push --force";
          gpf = "git push --force-with-lease --force-if-includes";
          gpsup = "git push --set-upstream origin";
          grb = "git rebase";
          grbi = "git rebase -i origin/@{upstream}";
          grh = "git reset";
          grhs = "git reset --soft";
          grs = "git restore";
          grst = "git restore --staged";
          gsph = "git stash push";
          gspp = "git stash pop";
          gst = "git status";
          gwipe = "git reset --hard && git clean --force -df";
        };

        siteFunctions = {
          gcm = ''
            x=$(git checkout master 2>&1)
            if [ $? -ne 0 ]; then
              git checkout main 2>/dev/null || (echo "$x"; exit 1)
            fi
          '';

          gssh = ''
            if [[ -z "$1" ]]; then
              git stash list
            else
              git stash list | tail -n "$1" | head -1
              git stash show "$1"
            fi
          '';
        };
      };
    };
  };

  our.nix-config.includes = [a.vcs];
}
