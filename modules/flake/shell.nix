{
  lib,
  den,
  ...
}:
{
  flake-file.inputs = {
    nix-auto-follow = {
      url = "github:fzakaria/nix-auto-follow";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
  };

  perSystem =
    {
      pkgs,
      inputs',
      self',
      ...
    }:
    {
      devShells.default =
        let
          denApps = den.lib.nh.denApps {
            outPrefix = [ ];
            fromFlake = true;
          } pkgs;

          fmtt = pkgs.writeShellApplication {
            name = "fmtt";
            text = ''
              ${lib.getExe self'.formatter} "$@"
            '';
          };

          nix-fast-build = inputs'.nix-fast-build.packages.default;
          auto-follow = inputs'.nix-auto-follow.packages.default;
          shellHook = "export NH_SHOW_ACTIVATION_LOGS=true";
        in
        pkgs.mkShell {
          inherit shellHook;
          buildInputs = denApps ++ [
            auto-follow
            nix-fast-build
            fmtt
            pkgs.age
            pkgs.cachix
            pkgs.git
            pkgs.just
            pkgs.nh
            pkgs.sops
          ];
        };
    };
}
