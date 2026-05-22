{
  config,
  den,
  lib,
  ...
}:
let
  updateInputs = config.nix-config.primaryInputs;

  perSystem =
    { pkgs, self', ... }:
    let
      # Responsible for e.g. `user@hostname switch` to alias darwin-rebuild
      # commands for convenience.
      activatePkgs = den.lib.nh.denPackages { fromFlake = true; } pkgs;

      fmtt = self'.formatter;

      update = pkgs.writeShellApplication {
        name = "update-primary";
        meta.description = "Update primary flake inputs";
        text = ''
          nix flake update${lib.foldl' (acc: x: acc + " " + x) "" updateInputs}
        '';
      };
    in
    {
      packages = activatePkgs // {
        inherit (pkgs) nix-fast-build;
        inherit fmtt update;
      };
    };
in
{
  inherit perSystem;
}
