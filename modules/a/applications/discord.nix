{ a, den, ... }:
{
  our.nix-config.includes = [
    a.discord
    (den._.unfree [ "discord" ])
  ];

  a.discord.homeManager.programs.discord.enable = true;
}
