{
  config,
  lib,
  den,
  inputs,
  ...
}: let
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    # All host/home activation wrapper packages.
    activatePkgs = den.lib.nh.denPackages {fromFlake = true;} pkgs;
    fmtt = pkgs.writeShellApplication {
      name = "fmtt";
      text = ''${lib.getExe self'.formatter} "$@"'';
    };
    replf = pkgs.writeShellApplication {
      name = "nrepl";
      text = ''nix repl --expr "builtins.getFlake \"${../.}\""'';
    };
    update = pkgs.writeShellApplication {
      name = "update-primary";
      text = ''
        nix flake update${lib.foldl' (acc: x: acc + " " + x) "" config.nix-config.primaryInputs}
      '';
      meta.description = "Update primary flake inputs";
    };
  in {
    devShells.default = pkgs.mkShell {
      env.NH_SHOW_ACTIVATION_LOGS = "1";
      packages =
        [
          fmtt
          pkgs.age
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
    packages =
      activatePkgs
      // {
        inherit update;
      };
    treefmt = {
      programs = {
        alejandra.enable = true;
        deadnix.enable = true;
        pedantix = {
          enable = true;
          settings = {
            format-after-sort = true;
            formatter = "alejandra";
            lets.sort = true;
            overrides = let
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
      settings.global.exclude = [
        ".direnv/"
        "modules/our/*.yaml"
        "modules/our/public_keys/*"
      ];
    };
  };
in {
  inherit perSystem;
  imports = [
    ./_ci
    inputs.treefmt-nix.flakeModule
    inputs.pedantix.flakeModules.default
  ];
}
