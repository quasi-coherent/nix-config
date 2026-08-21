{ a, ... }:
{
  a.terminal.alacritty.homeManager =
    { config, ... }:
    {
      programs = {
        alacritty = {
          enable = true;

          settings = {
            # Start in tmux.
            env.TERM = "tmux-256color";

            general.import = [
              "${config.xdg.configHome}/alacritty/alacritty.common.toml"
              "${config.xdg.configHome}/alacritty/keybindings.toml"
            ];

            terminal = {
              osc52 = "CopyPaste";

              shell = {
                args = [
                  "-l"
                  "-c"
                  "${config.programs.tmux.package}/bin/tmux new -As tmux"
                ];

                program = "${config.programs.zsh.package}/bin/zsh";
              };
            };
          };
        };
      };

      xdg.configFile.alacritty = {
        recursive = true;
        source = ./files/alacritty;
      };
    };

  our.nix-config.includes = [ a.terminal.alacritty ];
}
