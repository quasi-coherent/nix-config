{lib, ...}: {
  options.nix-config = lib.mkOption {
    type = lib.types.submodule {
      options = {
        primaryInputs = lib.mkOption {
          default = [];
          description = "Flake inputs that should be updated regularly.";
          type = with lib.types; listOf str;
        };
      };
    };
  };
  config.nix-config.primaryInputs = [
    "darwin"
    "emacs-overlay"
    "fenix"
    "home-manager"
    "nixpkgs"
  ];
}
