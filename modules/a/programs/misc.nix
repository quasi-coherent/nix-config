{ a, den, ... }:
{
  a.programs.misc = {
    includes = [
      (den.batteries.unfree [
        "1password"
        "1password-cli"
      ])
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          stockfish
        ];

        programs = {
          spotify-player.enable = true;
          streamlink.enable = true;
          yt-dlp.enable = true;
        };
      };

    darwin.programs._1password.enable = true;
    darwin.programs._1password-gui.enable = true;
  };

  our.nix-config.includes = [ a.programs.misc ];
}
