{ a, ... }:
{
  our.nix-config.includes = [ a.gpg ];

  a.gpg.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.gnupg ];
    };
}
