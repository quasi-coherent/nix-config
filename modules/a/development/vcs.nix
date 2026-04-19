{ a, ... }:
{
  our.nix-config.includes = [ a.vcs ];

  a.vcs.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.difftastic ];

      programs.git = {
        enable = true;
        lfs.enable = true;

        ignores = [
          ".*"
          "!.gitignore"
          "!.envrc"
          "*.swp"
          "*.key"
          "target"
          "result"
          "out"
          "old"
        ];

        settings = {
          init.defaultBranch = "master";
          pull.rebase = true;
          push.default = "current";
          push.autoSetupRemote = true;
          pager.difftool = true;
          diff.tool = "difftastic";
          difftool.prompt = false;
          difftool.difftastic.cmd = "${pkgs.difftastic}/bin/difft $LOCAL $REMOTE";
        };
      };

      programs.delta = {
        enable = true;
        enableGitIntegration = true;
        enableJujutsuIntegration = true;
        options = {
          line-numbers = true;
          side-by-side = false;
        };
      };

      programs.zsh.shellAliases = {
        g = "git";
        ga = "git add";
        gaa = "git add --all";
        gconf = "git config";
        gconfls = "git config --list";
        gclean = "git clean --interactive -d";
        gco = "git checkout";
        gcount = "git shortlog --summary --numbered";
        gcb = "git checkout -b";
        gcm = "git checkout master 2>/dev/null || git checkout main";
        gc = "git commit --verbose";
        gb = "git branch";
        gbd = "$git branch -d";
        gbD = "$git branch -D";
        gd = "git diff";
        gdc = "git diff --cached";
        gdup = "git diff @{upstream}";
        gdn = "git rev-list --count --left-right @{upstream}..";
        gg = "git grep";
        ggf = "git ls-files | grep";
        gl = "git pull --rebase";
        gla = "git pull --autostash";
        glo = "git log --oneline --decorate";
        glog = "git log --graph";
        gllog = "git log --graph --all";
        glogp = "git log --stat --patch";
        gp = "git push";
        gpf = "git push --force-with-lease --force-if-includes";
        gpF = "git push --force";
        gpsup = "git push --set-upstream origin";
        gst = "git status";
        grb = "git rebase";
        grbi = "git rebase -i origin/@{upstream}";
        grh = "git reset";
        grhs = "git reset --soft";
        grs = "git restore";
        grst = "git restore --staged";
        gwipe = "git reset --hard && git clean --force -df";
      };
    };
}
