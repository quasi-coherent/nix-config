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
      (den.batteries.insecure [ "electron-40.10.5" ])
    ];

    homeManager = {
      programs.vesktop = {
        enable = true;
        vencord.settings = {
          autoUpdate = false;
          autoUpdateNotification = false;
          disableMinSize = true;
          notifyAboutUpdates = false;
        };
      };
    };
  };
}
