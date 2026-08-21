{ a, ... }:
{
  a.colima.homeManager.services.colima.enable = true;
  our.nix-config.includes = [ a.colima ];
}
