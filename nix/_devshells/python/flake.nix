{
  inputs = {
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lib.follows = "nixpkgs";
    pyproject = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:pyproject-nix/pyproject.nix";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem =
        { pkgs, ... }:
        let
          arg = prj.renderers.withPackages { inherit (pyPkgs) python; };
          prj = inputs.pyproject.lib.project.loadPyproject { inherit projectRoot; };
          projectRoot = ./.;
          pyPkgs = pkgs.python314Packages;
          pythonEnv = pyPkgs.python.withPackages arg;
        in
        {
          devShells.default = pkgs.mkShell {
            packages = [
              pythonEnv
              pyPkgs.ruff
              pyPkgs.python-lsp-ruff
            ];
          };
        };
      systems = [
        "x86_64-darwin"
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
}
