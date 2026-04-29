{ a, ... }:
{
  our.nix-config.includes = [ a.ocaml ];

  a.ocaml.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        dune_3
        ocaml
        ocamlPackages.findlib
        ocamlPackages.lsp
        ocamlPackages.ocamlformat
        ocamlPackages.odoc
        ocamlPackages.reason
        ocamlPackages.rtop
        ocamlPackages.utop
      ];
    };
}
