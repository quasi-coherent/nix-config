{
  # a,
  den,
  inputs,
  ...
}:
{
  flake-file.inputs.spicetify-nix = {
    url = "github:Gerg-L/spicetify-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # https://github.com/NixOS/nixpkgs/issues/465676
  # our.nix-config.includes = [ a.spotify ];

  a.spotify = {
    includes = [ (den._.unfree [ "spotify" ]) ];

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
            focusMode
            fullAppDisplay
            groupSession
            history
            loopyLoop
            phraseToPlaylist
            playlistIntersection
            sessionStats
            shuffle
            songStats
            skipStats
            wikify
	  ];
	};
      };
  };
}
