{
  inputs = {
    fenix.inputs.nixpkgs.follows = "nixpkgs";
    fenix.url = "github:nix-community/fenix";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    nixpkgs-lib.follows = "nixpkgs";
  };

  ## Uncomment to add the fenix binary cache to trusted substituters.
  # nixConfig = {
  #   extra-substituters = [ "https://fenix.cachix.org" ];
  #   extra-trusted-public-keys = [
  #     "fenix.cachix.org-1:ecJhr+RdYEdcVgUkjruiYhjbBloIEGov7bos90cZi0Q="
  #   ];
  # };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      perSystem = {
        pkgs,
        inputs',
        ...
      }: let
        # inputs'.fenix.packages.latest is the nightly toolchain.
        #
        # If switching to stable, it is common to want `rustfmt` from nightly
        # still, since it's pretty much useless otherwise.  In this case, use
        # fenix.combine to make a toolchain with everything from stable except
        # rustfmt:
        #
        # toolchain =
        # let
        #   stable = inputs'.fenix.packages.stable;
        #   nightly = inputs'.fenix.packages.minimal;
        # in
        #   inputs'.fenix.combine [
        #     stable.cargo
        #     stable.clippy
        #     stable.rustc
        #     stable.rust-src
        #     stable.rust-analyzer
        #     nightly.rustfmt
        #   ];
        toolchain = inputs'.fenix.packages.default;
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            cargo-expand
            cargo-flamegraph
            cargo-machete
            cargo-watch
            (toolchain.withComponents [
              "cargo"
              "clippy"
              "rust-src"
              "rustc"
              "rustfmt"
              "rust-analyzer"
            ])
          ];
        };
      };
      systems = [
        "x86_64-darwin"
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
    };
}
