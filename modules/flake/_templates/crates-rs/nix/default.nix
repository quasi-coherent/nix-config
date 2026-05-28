{ inputs, ... }:
{
  imports = [
    inputs.treefmt-nix.flakeModule
    ./checks.nix
    ./crate.nix
    ./lib.nix
  ];

  perSystem =
    {
      crane,
      rustTools,
      lib,
      pkgs,
      self',
      ...
    }:
    let
      fmtt = pkgs.writeShellApplication {
        name = "fmtt";
        text = ''${lib.getExe self'.formatter} "$@"'';
      };
    in
    {
      apps.default = {
        meta = "Format project source";
        program = fmtt;
      };

      devShells.default = crane.devShell {
        inputsFrom = [ self'.formatter ];
        RUST_SRC_PATH = "${rustTools.rust-src}/lib/rustlib/src/rust/library";
        packages = [
          fmtt
          pkgs.cachix
          pkgs.just
          pkgs.nixd
          pkgs.nix-output-monitor
          rustTools.toolchain
        ];
      };

      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          rustfmt.enable = true;
          nixfmt.enable = true;
          typos.enable = true;
        };
        settings.formatter.rustfmt = {
          options = [
            "--config-path"
            "rustfmt.toml"
          ];
        };
      };
    };
}
