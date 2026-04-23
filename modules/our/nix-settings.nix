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
