{
  our.xdg.homeManager =
    { config, ... }:
    let
      home = config.home.homeDirectory;
    in
    {
      xdg.enable = true;

      xdg.binHome = "${home}/.bin";

      xdg.userDirs = {
        enable = true;
        setSessionVariables = true;
        createDirectories = true;

        desktop = "${home}/Desktop";
        documents = "${home}/Documents";
        download = "${home}/Downloads";
        music = "${home}/Music";
        pictures = "${home}/Pictures";
        publicShare = "${home}/Public";
        templates = "${home}/.Templates";

        extraConfig = {
          MISC = "${home}/Misc";
          TMP = "${home}/tmp";
          D = "${home}/d";
        };
      };

      xdg.configFile.alacritty = {
        source = ./config/alacritty;
        recursive = true;
      };

      xdg.configFile.emacs = {
        source = ./config/emacs;
        recursive = true;
      };

      xdg.configFile.tmux = {
        source = ./config/tmux;
        recursive = true;
      };
    };
}
