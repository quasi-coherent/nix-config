{
  a,
  inputs,
  ...
}:
{
  a.programs.nix.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        dix
        manix
        nix-diff
        nix-du
        nix-inspect
        nix-melt
        nix-output-monitor
        nix-tree
        nix-web
        nixtract
        optnix
      ];

      imports = [ inputs.nix-index-database.homeModules.nix-index ];

      programs = {
        devenv = {
          enable = true;
          enableZshIntegration = true;
        };

        nix-index = {
          enable = true;
          enableZshIntegration = true;
        };

        nix-index-database.comma.enable = true;

        nix-search-tv = {
          enable = true;
          enableTelevisionIntegration = true;
        };
      };
    };

  our.nix-config.includes = [ a.programs.nix ];
}
