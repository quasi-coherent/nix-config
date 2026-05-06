{ inputs, ... }:
let
  flake-parts-lib = inputs.flake-parts.lib;
  inherit (flake-parts-lib) mkPerSystemOption;
in
{
  options.perSystem = mkPerSystemOption (
    {
      config,
      pkgs,
      ...
    }:
    let
      inherit (pkgs) lib;
      inherit (lib) types;
    in
    {
      options.nix-config = lib.mkOption {
        default = { };
        type = types.submodule {
          options = {
            primary-inputs = lib.mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = ''
                List of flake inputs to update regularly.
              '';
            };
          };
        };
      };
      config.packages.update =
        let
          inputs = config.nix-config.primary-inputs;
        in
        pkgs.writeShellApplication {
          name = "update-primary-inputs";
          meta.description = "Update primary flake inputs";
          text = ''
            nix flake update${lib.foldl' (acc: x: acc + " " + x) "" inputs}
          '';
        };
    }
  );
}
