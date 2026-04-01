{ ... }:
{
  a.tmux.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        tmux
        tmuxPlugins.logging
        tmuxPlugins.pain-control
        tmuxPlugins.prefix-highlight
        tmuxPlugins.tmux-thumbs
        tmuxPlugins.tmux-which-key
        tmuxPlugins.yank
      ];

      xdg.configFile.tmux.source = ./etc/tmux;
      xdg.configFile.tmux.recursive = true;
    };
}
