{ a, ... }:
{
  our.nix-config.includes = [ a.colima ];

  a.colima.homeManager =
    { config, ... }:
    {
      services.colima = {
        enable = true;
        colimaHomeDir = "${config.xdg.configHome}/colima";
      };
    };
}
