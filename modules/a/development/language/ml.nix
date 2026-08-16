{
  a,
  inputs,
  ...
}: {
  a.ocaml.homeManager = {pkgs, ...}: {
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

    nixpkgs.overlays = [inputs.ocaml-overlay.overlays.default];
  };

  our.disabled.includes = [a.ocaml];
}
