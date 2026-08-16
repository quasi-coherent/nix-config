{a, ...}: {
  a.programs.misc.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      stockfish
    ];

    programs = {
      spotify-player.enable = true;
      streamlink.enable = true;
      yt-dlp.enable = true;
    };
  };

  our.nix-config.includes = [a.programs.misc];
}
