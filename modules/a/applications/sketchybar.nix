{ a, ... }:
{
  our.nix-config.includes = [ a.sketchybar ];

  # a.sketchybar.homeManager =
  #   { pkgs, ... }:
  #   let
  #     sketchybar = pkgs.sketchybar;
  #   in
  #   {
  #     home.packages = [ sketchybar ];

  #     launchd.agents.sketchybar = {
  #       enable = false;
  # 	# label = "org.${config.home.username}.sketchybar";
  #       config = {
  #           ProgramArguments = [
  # 	      "${pkgs.runtimeShell}"
  #             "-l"
  #             "-c"
  #             "${sketchybar}/bin/sketchybar"
  #         ];
  #         KeepAlive = true;
  #       };
  #     };
  #   };

  a.sketchybar.darwin.services.sketchybar.enable = true;
}
