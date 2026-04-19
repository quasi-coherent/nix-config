{ a, ... }:
{
  our.nix-config.includes = [ a.sketchybar ];

  a.sketchybar.darwin =
    { lib, pkgs, ... }:
    let
      sketchybar-bin = pkgs.callPackage ./_sketchybar { };
    in
    {
      services.sketchybar = {
        enable = true;
        config = ''${lib.getBin sketchybar-bin}/bin/sketchybar.sh'';
        extraPackages = [ pkgs.jq sketchybar-bin ];
      };
    };
}
