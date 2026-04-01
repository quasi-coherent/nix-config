{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  flake-file.inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix = "github:numtide/treefmt-nix";
    home-manager.url = "github:nix-community/home-manager";
  };
}
