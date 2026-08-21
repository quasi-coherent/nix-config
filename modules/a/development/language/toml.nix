{ a, ... }:
{
  a.toml.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.taplo ];
    };

  our.nix-config.includes = [ a.toml ];
}
