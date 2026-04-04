{ a, ... }:
{
  our.nix-config.includes = [ a.bash ];

  a.bash.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.bash-language-server ];
    };
}
