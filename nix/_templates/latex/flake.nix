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
              outlines
              rsfs
              scheme-medium
              wrapfig
              ;
          };
        in
        {
          packages.default = pkgs.callPackage ./doc.nix { inherit tex; };
        };
    };
}
