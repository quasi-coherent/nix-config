{ ... }:
{
  flake-file.inputs.trix.url = "github:aanderse/trix";

  a.nix.homeManager =
    { pkgs, inputs', ... }:
    {
      home.packages = [
        inputs'.trix.packages.trix
        pkgs.cachix
        pkgs.deadnix
        pkgs.nix-output-monitor
        pkgs.nix-tree
        pkgs.nixd
        pkgs.nixpkgs-fmt
      ];
    };
}
