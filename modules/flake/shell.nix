{
  lib,
  den,
  ...
}:
{
  flake-file.inputs.nix-fast-build = {
    url = "github:Mic92/nix-fast-build";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-parts.follows = "flake-parts";
    inputs.treefmt-nix.follows = "treefmt-nix";
  };

  perSystem =
    {
      pkgs,
      inputs',
      self',
      ...
    }:
    let
      denApps = den.lib.nh.denApps {
        outPrefix = [ ];
        fromFlake = true;
      } pkgs;

      fmtt = pkgs.writeShellApplication {
        name = "fmtt";
        text = ''${lib.getExe self'.formatter} "$@"'';
      };

      replf = pkgs.writeShellApplication {
        name = "nrepl";
        text = ''nix repl --expr "builtins.getFlake \"${../..}\""'';
      };

      nix-fast-build = inputs'.nix-fast-build.packages.default;
      trix = inputs'.trix.packages.default;
    in
    {
      devShells.default = pkgs.mkShell {
        NH_SHOW_ACTIVATION_LOGS = "1";
        buildInputs = denApps ++ [
          fmtt
          nix-fast-build
          pkgs.age
          pkgs.cachix
          pkgs.git
          pkgs.just
          pkgs.nh
          pkgs.sops
          replf
          trix
        ];
      };
    };
}
