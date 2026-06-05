{
  a,
  den,
  ...
}:
{
  our.nix-config.includes = [ a.discord ];

  a.discord = {
    includes = [
      (den.batteries.unfree [ "discord" ])
    ];

    homeManager = {
      programs.vesktop = {
        enable = true;
        vencord.settings = {
          autoUpdate = false;
          autoUpdateNotification = false;
          disableMinSize = true;
          notifyAbountUpdates = false;
        };
      };
    };
  };
}
