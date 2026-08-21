{
  a,
  den,
  ...
}:
{
  a.obsidian = {
    includes = [
      (den.batteries.unfree [
        "obsidian"
      ])
    ];

    homeManager.programs.obsidian = {
      cli.enable = true;
      enable = true;
    };
  };

  our.nix-config.includes = [ a.obsidian ];
}
