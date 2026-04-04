{ lib, ... }:
{
  our.nix-settings = {
    os =
      { pkgs, ... }:
      {
        nix = {
          # Use the lix installer not CppNix.
          package = pkgs.lix;

          settings = {
            extra-experimental-features = [
              "nix-command"
              "flakes"
            ];
            substituters = [
              "https://quasi-coherent.cachix.org"
              "https://nix-community.cachix.org"
            ];
            trusted-public-keys = [
              "quasi-coherent.cachix.org-1:3+u75bSX52FuYz64LAqVEY9+/FPztofTDfz7p9UTBEA="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            ];
            trusted-users = [
              "root"
              "@wheel"
            ];
          };
          optimise.automatic = true;
          gc.automatic = true;
          gc.options = "--delete-older-than 14d";
        };
      };

    # This avoids evaluating nixpkgs all the time.
    homeManager.nix.registry = lib.mapAttrs (_name: v: { flake = v; }) { };
  };
}
