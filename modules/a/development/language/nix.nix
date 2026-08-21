{ a, ... }:
{
  a.nixlang.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.deadnix
        pkgs.nixd
        pkgs.statix
      ];
    };

  our.nix-config.includes = [ a.nixlang ];
}
