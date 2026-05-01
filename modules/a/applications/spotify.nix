{
  a,
  den,
  inputs,
  ...
}:
{
  flake-file.inputs.spicetify-nix = {
    url = "github:Gerg-L/spicetify-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  our.nix-config.includes = [
    a.spotify
    (den._.unfree [
      "spotify"
      "spicetify-nix"
    ])
  ];

  a.spotify = {
    homeManager =
      { inputs', ... }:
      let
        spiceExts = inputs'.spicetify-nix.legacyPackages.extensions;
      in
      {
        imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

        programs.spicetify = {
          enable = true;
          enabledExtensions = with spiceExts; [
            betterGenres
            groupSession
            history
            loopyLoop
            playlistIntersection
            shuffle
            songStats
            skipStats
            wikify
          ];
        };
      };
  };
}
