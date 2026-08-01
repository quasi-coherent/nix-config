{ inputs, ... }:
{
  imports = [
    inputs.den.flakeModules.default
    inputs.flake-file.flakeModules.default
    inputs.treefmt-nix.flakeModule
    (inputs.import-tree ../modules)
  ];

  flake-file.inputs = {
    den.url = "github:vic/den";
    flake-file.url = "github:vic/flake-file";
    import-tree.url = "github:vic/import-tree";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
