{
  our.xdg.homeManager =
    { config, ... }:
    {
      xdg.enable = true;

      xdg.binHome = "${config.home.homeDirectory}/.bin";

      xdg.userDirs = {
        enable = true;
        setSessionVariables = true;
        createDirectories = true;

        desktop = "${config.home.homeDirectory}/Desktop";
        documents = "${config.home.homeDirectory}/Documents";
        download = "${config.home.homeDirectory}/Downloads";
        music = "${config.home.homeDirectory}/Music";
        pictures = "${config.home.homeDirectory}/Pictures";
        publicShare = "${config.home.homeDirectory}/Public";
        templates = "${config.home.homeDirectory}/.Templates";

        extraConfig = {
          MISC = "${config.home.homeDirectory}/Misc";
          TMP = "${config.home.homeDirectory}/tmp";
          D = "${config.home.homeDirectory}/d";
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

      xdg.configFile.sketchybar = {
        source = ./config/sketchybar;
        recursive = true;
      };

      xdg.configFile.tmux = {
        source = ./config/tmux;
        recursive = true;
      };
    };
}
