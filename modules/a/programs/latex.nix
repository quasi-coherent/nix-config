{ a, ... }:
{
  # @@@@@
  our.disabled.includes = [ a.latex ];

  a.latex.homeManager =
    { pkgs, ... }:
    let
      tex = pkgs.texliveFull.withPackages (
        ps: with ps; [
          amsmath
          dvipng
          dvisvgm
          geometry
          lm
          luatex
          moderncv
          rsfs
          wrapfig
        ]
      );
    in
    {
      home.packages = [ tex ];
    };
}
