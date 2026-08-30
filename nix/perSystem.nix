{
  config,
  lib,
  den,
  inputs,
  ...
}:
let
  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    let
      # All host/home activation wrapper packages.
      activatePkgs = den.lib.nh.denPackages { fromFlake = true; } pkgs;

      fmtt = pkgs.writeShellApplication {
        name = "fmtt";
        text = ''${lib.getExe self'.formatter} "$@"'';
      };
      replf = pkgs.writeShellApplication {
        name = "replf";
        text = ''nix repl --expr "builtins.getFlake \"${../.}\""'';
      };
      update-primary = pkgs.writeShellApplication {
        name = "update-primary";
        text = ''
          nix flake update${lib.foldl' (acc: x: acc + " " + x) "" config.nix-config.primaryInputs}
        '';
      };
    in
    {
      devShells.default = pkgs.mkShell {
        env.NH_SHOW_ACTIVATION_LOGS = "1";
        packages = [
          fmtt
          pkgs.age
          pkgs.devenv
          pkgs.cachix
          pkgs.flake-edit
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
      packages = activatePkgs // {
        inherit update-primary;
      };
      treefmt = {
        programs = {
          deadnix.enable = true;
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rs;
          };
          pedantix = {
            enable = true;
            settings = {
              format-after-sort = true;
              formatter = "nixfmt";
              lets.sort = true;
              overrides =
                let
                  f = path: {
                    inherit path;
                    attrs.first = [
                      "includes"
                      "homeManager"
                      "darwin"
                      "nixos"
                      "os"
                    ];
                  };
                in
                map f [
                  "our.**"
                  "a.**"
                  "me.**"
                ];
              preset = "nixos-module";
            };
          };
          statix.enable = true;
          typos.enable = true;
        };
        projectRootFile = ".git/config";
        settings.formatter.flake-edit = {
          options = [
            "--non-interactive"
            "--no-lock"
            "follow"
          ];
          command = pkgs.flake-edit;
          includes = [ "flake.nix" ];
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
  imports = [
    ./_ci
    inputs.treefmt-nix.flakeModule
    inputs.pedantix.flakeModules.default
  ];
}
