{ ... }:
{
  our.nix-settings = {
    os =
      { pkgs, ... }:
      {
        nix = {
          # TODO: is this better somewhere else?
          package = pkgs.lix;

          optimise.automatic = true;

          settings = {
            experimental-features = [
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

          gc = {
            automatic = true;
            options = "--delete-older-than 14d";
          };
        };
      };
  };
}
