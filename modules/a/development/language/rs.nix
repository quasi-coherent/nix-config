{
  a,
  inputs,
  ...
}:
{
  a.rust = {
    homeManager =
      { pkgs, ... }:
      {
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
            cargo-flamegraph
            cargo-llvm-cov
            cargo-machete
            cargo-show-asm

            # Occasionally useful command to clean up Rust target bloat.
            (pkgs.writeShellScriptBin "cargo-clean-all" ''fd -g Cargo.toml -X sh -c 'cd {//} && rm -rf target/' "$1"'')
          ]
          ++ nightly;

        nixpkgs.overlays = [ inputs.fenix.overlays.default ];
      };

    os = {
      nix.settings.substituters = [
        "http://fenix.cachix.org"
      ];
      nix.settings.trusted-public-keys = [
        "fenix.cachix.org-1:ecJhr+RdYEdcVgUkjruiYhjbBloIEGov7bos90cZi0Q="
      ];
    };
  };

  our.nix-config.includes = [ a.rust ];
}
