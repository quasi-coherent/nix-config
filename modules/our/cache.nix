{ ... }:
{
  our.cache = {
    os.nix.settings = {
      substituters = [
        "https://quasi-coherent.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "quasi-coherent.cachix.org-1:3+u75bSX52FuYz64LAqVEY9+/FPztofTDfz7p9UTBEA="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    homeManager =
      { config, pkgs, ... }:
      let
        cachix-exec = pkgs.callPackage ./_pkgs/cachix-exec.nix { inherit config; };
      in
      {
        home.packages = [
          cachix-exec
          pkgs.cachix
        ];
      };
  };
}
