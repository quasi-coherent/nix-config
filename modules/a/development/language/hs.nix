{ a, ... }:
{
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

  our.nix-config.includes = [ a.haskell ];
}
