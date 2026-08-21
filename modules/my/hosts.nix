{ our, ... }:
{
  den.aspects.hemlock = {
    includes = [
      our.darwin-system
      our.nix-settings
      our.theme
    ];
  };
}
