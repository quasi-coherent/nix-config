{ a, ... }:
{
  our.nix-config.includes = [ a.sketchybar ];

  a.sketchybar.homeManager =
    { config, pkgs, ... }:
    let
      sketchybar = pkgs.sketchybar;
    in
    {
      home.packages = [ sketchybar ];

      launchd.agents.sketchybar = {
        enable = true;
        config = {
          Label = "org.${config.home.username}.sketchybar";
          ProgramArguments = [
            "${sketchybar}/bin/sketchybar"
            "--config"
            "${config.xdg.configHome}/sketchybar/sketchybarrc"
          ];
          KeepAlive = true;
        };
      };
    };
}
