{ a, ... }:
{
  our.nix-config.includes = [ a.alacritty ];

  a.alacritty.homeManager =
    { config, ... }:
    {
      programs.alacritty.enable = true;
      programs.alacritty.settings = {
        general.import = [
          "${config.xdg.configHome}/alacritty/alacritty.common.toml"
          "${config.xdg.configHome}/alacritty/keybindings.toml"
        ];
        # Start in tmux.
        env.TERM = "tmux-256color";
        terminal = {
          osc52 = "CopyPaste";
          shell.program = "${config.programs.zsh.package}/bin/zsh";
          shell.args = [
            "-l"
            "-c"
            "${config.programs.tmux.package}/bin/tmux new -As tmux"
          ];
        };
      };
    };
}
