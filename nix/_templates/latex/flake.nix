{
  description = "A very basic flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-darwin" ];
      perSystem =
        { pkgs, ... }:
        let
          tex = pkgs.texlive.combine {
            # I dunno what you really need here.
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

          program = pkgs.writeShellApplication {
            name = "gen";
            runtimeInputs = [ tex ];
            text = ''
              TS="$(date '+%s')"

              cd ./src \
                && pdflatex doc.tex \
                && mv doc.pdf "../doc-$TS.pdf"
            '';
          };
        in
        {
          apps.default = { inherit program; };
        };
    };
}
