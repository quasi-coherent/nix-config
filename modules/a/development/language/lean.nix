{ a, ... }:
{
  our.nix-config.includes = [ a.lean ];

  a.lean.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.elan ];
    };
}
