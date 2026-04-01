{ ... }:
{
  a.micro.homeManager =
    { ... }:
    {
      programs.micro.enable = true;
      xdg.configFile.micro.source = ./etc/micro;
      xdg.configFile.micro.recursive = true;
    };
}
