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
      {
        nixpkgs.overlays = [ inputs.fenix.overlays.default ];

        home.packages =
          let
            nightly = with pkgs; [
              (fenix.complete.withComponents [
                "cargo"
                "clippy"
                "rust-src"
                "rustc"
                "rustfmt"
              ])
              rust-analyzer-nightly
            ];
          in
          with pkgs;
          [
            sccache
            cargo-expand
            cargo-flamegraph
            cargo-llvm-cov
            cargo-machete
            cargo-make
            cargo-msrv
            cargo-show-asm
            cargo-sort
            cargo-watch

            # Occasionally useful command to clean up Rust target bloat.
            (pkgs.writeShellScriptBin "cargo-clean-all" ''fd -g Cargo.toml -X sh -c 'cd {//} && rm -rf target/' "$1"'')
          ]
          ++ nightly;
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
