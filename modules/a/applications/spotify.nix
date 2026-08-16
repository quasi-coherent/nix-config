{
  a,
  den,
  inputs,
  ...
}: {
  a.spotify = {
    includes = [
      (den.batteries.unfree [
        "spotify"
        "spicetify-nix"
      ])
    ];

    homeManager = {inputs', ...}: let
      spiceExts = inputs'.spicetify-nix.legacyPackages.extensions;
    in {
      imports = [inputs.spicetify-nix.homeManagerModules.spicetify];

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

  our.nix-config.includes = [a.spotify];
}
