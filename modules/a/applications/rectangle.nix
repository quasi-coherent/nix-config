{ a, ... }:
{
  our.nix-config.includes = [ a.rectangle ];

  a.rectangle.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.rectangle ];
    };
}
