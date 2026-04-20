{ a, ... }:
{
  our.nix-config.includes = [ a.latex ];

  a.latex.homeManager =
    { pkgs, ... }:
    let
      tex = pkgs.texlive.combine {
        inherit (pkgs.texlive)
          amsmath
          dvipng
          dvisvgm
          geometry
          lm
          luatex
          moderncv
          rsfs
          scheme-medium
          wrapfig
          ;
      };
    in
    {
      home.packages = [ tex ];
    };
}
