inputs:
inputs.flake-parts.lib.mkFlake { inherit inputs; } {
  systems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-linux"
  ];
  imports = [ (inputs.import-tree ./nix) ];
}
