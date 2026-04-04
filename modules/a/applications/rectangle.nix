{ a, lib, ... }:
{
  our.nix-config.includes = [ a.rectangle ];

  a.rectangle.homeManager =
    { pkgs, ... }:
    {
      # home.packages = lib.optionals pkgs.stdenvNoCC.isDarwin pkgs.rectangle;
      home.packages = [ pkgs.rectangle ];
    };
}
