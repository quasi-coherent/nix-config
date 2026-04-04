{ a, ... }:
{
  our.nix-config.includes = [ a.pandoc ];

  a.pandoc.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        pandoc
        pandoc-imagine
        pandoc-ext-diagram
        pandoc-lua-filters
      ];
    };
}
