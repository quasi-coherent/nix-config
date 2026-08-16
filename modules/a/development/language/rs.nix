{
  a,
  inputs,
  ...
}: {
  a.rust = {
    homeManager = {pkgs, ...}: {
      home.packages = let
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

      nixpkgs.overlays = [inputs.fenix.overlays.default];
    };
  };

  our.nix-config.includes = [a.rust];
}
