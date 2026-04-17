{ a, ... }:
{
  our.nix-config.includes = [ a.tmux ];

  a.tmux.homeManager =
    { config, pkgs, ... }:
    let
      plugins = with pkgs.tmuxPlugins; [
        logging
        pain-control
        {
          plugin = tmux-thumbs;
          extraConfig = ''
            set -g @thumbs-contrast 1
            set -g @thumbs-key F
          '';
        }
        tmux-which-key
        {
          plugin = yank;
          extraConfig = ''
            set -g @yank-action copy-pipe
          '';
        }
        yank
      ];
      zshPkg = if config.programs.zsh.enable then config.programs.zsh.package else pkgs.zsh;
    in
    {
      programs.tmux.enable = true;

      programs.tmux = {
        inherit plugins;

        aggressiveResize = true;
        baseIndex = 1;
        clock24 = true;
        disableConfirmationPrompt = true;
        escapeTime = 0;
        extraConfig = ''
          source-file ${config.xdg.configHome}/tmux/tmux.common.conf
        '';
        focusEvents = false;
        historyLimit = 100000;
        keyMode = "emacs";
        newSession = true;
        shell = "${zshPkg}/bin/zsh";
        terminal = "tmux-256color";
      };


      # Enables stylix theme on the status bar and active pane.
      programs.zsh.envExtra = ''
        export TINTED_TMUX_OPTION_STATUSBAR=1
        export TINTED_TMUX_OPTION_ACTIVE=1
      '';
    };
}
