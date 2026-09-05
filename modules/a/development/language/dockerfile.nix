{ a, ... }:
{
  a.dockerfile.homeManager =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.dockerfile-language-server
      ];
    };

  our.nix-config.includes = [ a.dockerfile ];
}
