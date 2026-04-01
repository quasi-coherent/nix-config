{ config, ... }:
{
  a.zsh.homeManager =
    { pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        dotDir = "${config.xdg.configHome}/zsh";
      };

      home.packages = [
        pkgs.zsh-autosuggestions
        pkgs.zsh-autosuggestions-abbreviations-strategy
        pkgs.zsh-syntax-highlighting
      ];

      xdg.configFile.zsh.source = ./etc/zsh;
      xdg.configFile.zsh.recursive = true;
    };
}
