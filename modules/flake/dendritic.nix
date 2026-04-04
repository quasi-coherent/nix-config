{ inputs, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.default
    inputs.den.flakeModules.dendritic
  ];

  flake-file.inputs = {
    den.url = "github:vic/den";
    flake-file.url = "github:vic/flake-file";
    import-tree.url = "github:vic/import-tree";
  };
}
