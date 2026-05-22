{ a, ... }:
{
  our.nix-config.includes = [ a.colima ];
  a.colima.homeManager.services.colima.enable = true;
}
