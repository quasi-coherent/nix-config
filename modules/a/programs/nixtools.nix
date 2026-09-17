{
  a,
  inputs,
  ...
}:
{
  a.nixtools.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        deadnix
        dix
        manix
        nh
        nix-diff
        nix-du
        nix-inspect
        nix-melt
        nix-output-monitor
        nix-tree
        nix-web
        nixd
        nixfmt
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
        nix-search-tv.enable = true;
      };
    };

  our.nix-config.includes = [ a.nixtools ];
}
