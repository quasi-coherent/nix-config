{ our, ... }:
{
  den.aspects.hemlock = {
    includes = [
      our.darwin-system
      our.linux-builder
      our.nix-settings
    ];
  };
}
