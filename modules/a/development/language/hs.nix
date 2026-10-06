{ a, ... }:
{
  a.haskell.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cabal-install
        fourmolu
        ghc
        ghcid
        haskell-language-server
        stack
      ];
    };

  our.nix-config.includes = [ a.haskell ];
}
