{
  config,
  den,
  lib,
  ...
}:
let
  perSystem =
    {
      pkgs,
      inputs',
      self',
      ...
    }:
    let
      # All host/home activation wrapper packages.
      activatePkgs = den.lib.nh.denPackages { fromFlake = true; } pkgs;

      update = pkgs.writeShellApplication {
        name = "update-primary";
        meta.description = "Update primary flake inputs";
        text = ''
          nix flake update${lib.foldl' (acc: x: acc + " " + x) "" config.nix-config.primaryInputs}
        '';
      };
      fmtt = pkgs.writeShellApplication {
        name = "fmtt";
        text = ''${lib.getExe self'.formatter} "$@"'';
      };
      replf = pkgs.writeShellApplication {
        name = "nrepl";
        text = ''nix repl --expr "builtins.getFlake \"${../.}\""'';
      };
    in
    {
      packages = activatePkgs // {
        inherit update;
      };

      devShells.default = pkgs.mkShell {
        NH_SHOW_ACTIVATION_LOGS = "1";

        packages = [
          fmtt
          inputs'.trix.packages.default
          pkgs.age
          pkgs.cachix
          pkgs.git
          pkgs.just
          pkgs.nh
          pkgs.nix-fast-build
          pkgs.nixd
          pkgs.sops
          replf
        ]
        ++ builtins.attrValues activatePkgs;
      };

      treefmt = {
        projectRootFile = ".git/config";
        programs = {
          deadnix.enable = true;
          nixfmt.enable = true;
          typos.enable = true;
        };
        settings.global.exclude = [
          ".direnv/"
          "modules/our/*.yaml"
          "modules/our/public_keys/*"
        ];
      };
    };
in
{
  inherit perSystem;
}
