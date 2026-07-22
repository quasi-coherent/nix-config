{ a, ... }:
{
  our.nix-config.includes = [ a.tmux ];

  a.tmux.homeManager =
    { config, pkgs, ... }:
    let
      plugins = with pkgs.tmuxPlugins; [
        copycat
        logging
        pain-control
        {
          plugin = tmux-thumbs;
          extraConfig = ''
            set -g @thumbs-contrast 1
            set -g @thumbs-key F
          '';
        }
        {
          plugin = tmux-fzf;
          extraConfig = ''
            TMUX_FZF_LAUNCH_KEY="C-f"
            TMUX_FZF_ORDER="session|window|pane|clipboard|keybinding|command|process"
            TMUX_FZF_PANE_FORMAT="[#{window_name}] #{pane_current_command}  [#{pane_width}x#{pane_height}] [history #{history_size}/#{history_limit}, #{history_bytes} bytes] #{?pane_active,[active],[inactive]}"
          '';
        }
        tmux-which-key
        {
          plugin = yank;
          extraConfig = ''
            set -g @yank-action copy-pipe
          '';
        }
      ];
      zshPkg = if config.programs.zsh.enable then config.programs.zsh.package else pkgs.zsh;
    in
    {
      programs.fzf.tmux.enableShellIntegration = true;

      programs.tmux = {
        inherit plugins;
        enable = true;
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
    };
}
