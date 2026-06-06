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
              "https://limavm-nix.cachix.org"
              "https://tern.cachix.org"
            ];
            trusted-public-keys = [
              "quasi-coherent.cachix.org-1:3+u75bSX52FuYz64LAqVEY9+/FPztofTDfz7p9UTBEA="
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
              "limavm-nix.cachix.org-1:3tRE+cBpLSZlcb6Mjgxjif+QCG6mJXuDyjyMHHXgx8I="
              "tern.cachix.org-1:wkC6dqWR8tLGcrTI40AOPQ48BdZaYXP/aen9znVbAMc="
            ];
            trusted-users = [ "@wheel" ];
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
