{ a, ... }:
{
  a.nu.homeManager =
    {
      pkgs,
      ...
    }:
    {
      home.packages = [
        pkgs.nushell
        pkgs.nufmt
      ];
    };

  our.nix-config.includes = [ a.nu ];
}
