{ a, inputs, ... }:
{
  flake-file.inputs.fenix = {
    url = "github:nix-community/fenix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  our.nix-config.includes = [ a.rust ];

  a.rust = {
    homeManager =
      { pkgs, ... }:
      let
        fPkgs = inputs.fenix.packages.${pkgs.stdenvNoCC.hostPlatform.system};

        toolchain = with fPkgs.complete; [
          cargo
          clippy
          rustc
          rustfmt
          rust-src
        ];

        cargoCmds = with pkgs; [
          cargo-expand
          cargo-flamegraph
          cargo-llvm-cov
          cargo-machete
          cargo-make
          cargo-msrv
          cargo-show-asm
          cargo-sort
          cargo-tauri_1
          cargo-watch
        ];
      in
      {
        home.packages =
          toolchain
          ++ cargoCmds
          ++ [
            fPkgs.rust-analyzer
            pkgs.sccache

            # Occasionally useful command to clean up Rust target bloat.
            (pkgs.writeShellScriptBin "cargo-clean-all" ''fd -g Cargo.toml -X sh -c 'cd {//} && rm -rf target/' "$1"'')
          ];
      };

    # Always forward additional Rust cache config.
    os = {
      nix.settings.extra-trusted-public-keys = [
        "fenix.cachix.org-1:ecJhr+RdYEdcVgUkjruiYhjbBloIEGov7bos90cZi0Q="
      ];
      nix.settings.extra-substituters = [
        "http://fenix.cachix.org"
      ];
    };
  };
}
