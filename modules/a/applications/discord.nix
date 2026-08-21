{
  a,
  den,
  ...
}:
{
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

  our.nix-config.includes = [ a.discord ];
}
