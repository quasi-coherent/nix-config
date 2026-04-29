{ a, ... }:
{
  our.nix-config.includes = [ a.haskell ];

  a.haskell.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cabal-install
        ghc
        ghcid
        haskell-language-server
        ormolu
        stack
      ];
    };
}
