{ a, ... }:
{
  our.nix-config.includes = [ a.toml ];

  a.toml.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.taplo ];
    };
}
