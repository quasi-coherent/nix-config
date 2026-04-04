{ a, ... }:
{
  our.nix-config.includes = [ a.alacritty ];

  a.alacritty.homeManager =
    { config, pkgs, ... }:
    {
      programs.alacritty.enable = true;
      programs.alacritty = {
        package = pkgs.alacritty;
        settings = {
          general.import = [
            "${config.xdg.configHome}/alacritty/alacritty.toml.common"
            "${config.xdg.configHome}/alacritty/keybindings.toml"
          ];
          terminal.shell = {
            program = "${config.programs.zsh.package}/bin/zsh";
            args = [
              "-l"
              "-c"
              "${config.programs.tmux.package}/bin/tmux new -As tmux"
            ];
          };
          env.TERM = "tmux-256color";
        };
      };

      # Alacritty only accepts font declaration in alacritty.toml.
      stylix.targets.alacritty.fonts.enable = false;
    };
}
