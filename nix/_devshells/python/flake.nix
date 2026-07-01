{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lib.follows = "nixpkgs";
    pyproject = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-darwin"
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        let
          projectRoot = ./.;
          pyPkgs = pkgs.python314Packages;
          prj = inputs.pyproject.lib.project.loadPyproject { inherit projectRoot; };
          arg = prj.renderers.withPackages { inherit (pyPkgs) python; };
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
    };
}
