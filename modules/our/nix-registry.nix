{ lib, ... }:
{
  # To avoid evaluating a new nixpkgs every time.
  our.nix-registry.homeManager.nix.registry = lib.mapAttrs (_name: v: { flake = v; }) ({ });
}
