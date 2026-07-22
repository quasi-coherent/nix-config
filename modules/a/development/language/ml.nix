{ a, inputs, ... }:
{
  flake-file.inputs.ocaml-overlay = {
    url = "github:nix-ocaml/nix-overlays";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # @@@@@
  our.disabled.includes = [ a.ocaml ];

  a.ocaml.homeManager =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [ inputs.ocaml-overlay.overlays.default ];

      home.packages = with pkgs; [
        dune_3
        ocaml
        ocamlPackages.findlib
        ocamlPackages.ocamlformat
        ocamlPackages.odoc
        ocamlPackages.lsp
        ocamlPackages.melange
        ocamlPackages.merlin
        ocamlPackages.reason
        ocamlPackages.rtop
        ocamlPackages.utop
      ];
    };
}
