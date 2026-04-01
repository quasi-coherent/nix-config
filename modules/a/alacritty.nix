{ ... }:
{
  a.alacritty.homeManager =
    { ... }:
    {
      programs.alacritty.enable = true;
      xdg.configFile.alacritty.source = ./etc/alacritty;
      xdg.configFile.alacritty.recursive = true;
    };
}
