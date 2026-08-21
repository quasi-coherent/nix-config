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
      lib,
      pkgs,
      crane,
      rustTools,
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
        program = fmtt;
        meta = "Format project source";
      };

      devShells.default = crane.devShell {
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
        programs = {
          nixfmt.enable = true;
          rustfmt.enable = true;
          typos.enable = true;
        };
        projectRootFile = ".git/config";
        settings.excludes = [
          ".direnv/*"
        ];
      };
    };
}
