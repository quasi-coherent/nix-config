{
  nix-config.primaryInputs = [
    "darwin"
    "fenix"
    "home-manager"
    "nixpkgs"
  ];

  flake-file = {
    description = "my nix-config";

    nixConfig = {
      extra-trusted-public-keys = [
        "quasi-coherent.cachix.org-1:3+u75bSX52FuYz64LAqVEY9+/FPztofTDfz7p9UTBEA="
      ];
      extra-substituters = [ "https://quasi-coherent.cachix.org" ];
    };

    inputs = {
      flake-parts = {
        url = "github:hercules-ci/flake-parts";
        inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      };
      nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
      nixpkgs-lib.follows = "nixpkgs";
      systems.url = "github:nix-systems/default";
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
  };
}
