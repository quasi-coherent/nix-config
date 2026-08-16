{
  a,
  inputs,
  ...
}: {
  a.purescript.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      purs
      purs-tidy
      purs-backend-es
      spago
      purescript-language-server
    ];

    nixpkgs.overlays = [inputs.purescript-overlay.overlays.default];
  };

  our.nix-config.includes = [a.purescript];
}
