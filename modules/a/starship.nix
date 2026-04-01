{ config, ... }:
{
  a.starship.homeManager =
    { ... }:
    {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        configPath = "${config.xdg.configHome}/starship/starship.toml";
      };
      xdg.configFile.starship.source = ./etc/starship;
      xdg.configFile.starship.recursive = true;
    };
}
