{ a, ... }:
{
  our.nix-config.includes = [ a.latex ];

  a.latex.homeManager =
    { pkgs, ... }:
    let
      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive)
          luatex
          rsfs
          amsmath
          wrapfig
          scheme-medium
          dvisvgm
          dvipng
          ;
      };
    in
    {
      home.packages = [ tex ];
    };
}
