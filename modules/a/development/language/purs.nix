{ a, inputs, ... }:
{
  flake-file.inputs.purescript-overlay = {
    url = "github:thomashoneyman/purescript-overlay";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  our.nix-config.includes = [ a.purescript ];

  a.purescript.homeManager =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [ inputs.purescript-overlay.overlays.default ];

      home.packages = with pkgs; [
        purs
        purs-tidy
        purs-backend-es
        spago
        purescript-language-server
      ];
    };
}
