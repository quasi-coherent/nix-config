_: {
  our.home.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      home = config.home.homeDirectory;
    in
    {
      home.stateVersion = lib.mkDefault "26.05";

      manual = {
        html.enable = false;
        json.enable = false;
        manpages.enable = false;
      };

      programs.home-manager.enable = true;

      xdg = {
        binHome = "${home}/.bin";
        enable = true;

        userDirs = {
          createDirectories = true;
          enable = true;
          setSessionVariables = true;
        }
        // (lib.optionalAttrs pkgs.stdenvNoCC.hostPlatform.isDarwin {
          desktop = "${home}/Desktop";
          documents = "${home}/Documents";
          download = "${home}/Downloads";

          extraConfig = {
            MISC = "${home}/Misc";
            TMP = "${home}/tmp";
          };

          music = "${home}/Music";
          pictures = "${home}/Pictures";
          publicShare = "${home}/Public";
          templates = "${home}/.Templates";
        });
      };
    };
}
