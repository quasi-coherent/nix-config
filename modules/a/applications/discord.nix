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
  };

  our.nix-config.includes = [
    a.discord
    (den._.unfree [ "discord" ])
  ];

  a.discord.homeManager = {
    imports = [ inputs.nixcord.homeModules.nixcord ];

    programs.nixcord = {
      enable = true;
      discord.vencord.enable = true;
    };
  };
}
