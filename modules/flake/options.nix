{ lib, ... }:
{
  options.nix-config = lib.mkOption {
    type = lib.types.submodule {
      default = { };
      options = {
        primaryInputs = lib.mkOption {
          type = with lib.types; listOf str;
          description = "Flake inputs that should be updated regularly.";
          default = [ ];
        };
      };
    };
  };
}
