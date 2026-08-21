{
  description = "nix-config";
  inputs = {
    claude = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:sadjow/claude-code-nix?ref=v2.1.218";
    };
    darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-darwin/nix-darwin";
    };
    den.url = "github:vic/den";
    den-diagram = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:denful/den-diagram";
    };
    emacs-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/emacs-overlay";
    };
    fenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/fenix";
    };
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
      url = "github:hercules-ci/flake-parts";
    };
    github-actions = {
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:synapdeck/github-actions-nix";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    import-tree.url = "github:vic/import-tree";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-lib.follows = "nixpkgs";
    ocaml-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-ocaml/nix-overlays";
    };
    pedantix.inputs.flake-parts.follows = "flake-parts";
    pedantix.inputs.nixpkgs.follows = "nixpkgs";
    pedantix.inputs.treefmt-nix.follows = "treefmt-nix";
    pedantix.url = "github:swarsel/pedantix";
    purescript-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:thomashoneyman/purescript-overlay";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    spicetify-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Gerg-L/spicetify-nix";
    };
    stylix = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/stylix";
    };
    treefmt-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:numtide/treefmt-nix";
    };
  };
  nixConfig = {
    extra-substituters = [ "https://quasi-coherent.cachix.org" ];
    extra-trusted-public-keys = [
      "quasi-coherent.cachix.org-1:3+u75bSX52FuYz64LAqVEY9+/FPztofTDfz7p9UTBEA="
    ];
  };
  outputs = inputs: import ./outputs.nix inputs;
}
