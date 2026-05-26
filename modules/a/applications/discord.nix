{
  a,
  den,
  inputs,
  ...
}:
{
  flake-file.inputs.nixcord = {
    url = "github:FlameFlag/nixcord";
    inputs.flake-parts.follows = "flake-parts";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  our.nix-config.includes = [ a.discord ];

  a.discord = {
    includes = [
      (den.batteries.unfree [ "discord" ])
    ];

    homeManager =
      { ... }:
      {
        imports = [ inputs.nixcord.homeModules.nixcord ];

        nixpkgs.overlays = [
          (_: prev: {
            legcord = prev.callPackage ./_pkgs/legcord.nix { };
          })
        ];

        programs.nixcord = {
          enable = true;

          config = {
            frameless = true;
            transparent = true;
          };

          legcord = {
            enable = true;
            vencord.enable = true;

            settings = {
              channel = "stable";
              tray = "dynamic";
              minimizeToTray = true;
              mods = [ "vencord" ];
              doneSetup = true;
            };
          };
        };
      };
  };
}
