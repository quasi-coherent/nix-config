{
  a,
  inputs,
  ...
}: {
  a.nixtools.homeManager = {pkgs, ...}: {
    home.packages = [
      pkgs.deadnix
      pkgs.nh
      pkgs.nix-du
      pkgs.nix-inspect
      pkgs.nix-output-monitor
      pkgs.nix-tree
      pkgs.nix-web
      pkgs.nixd
      pkgs.nixfmt
      pkgs.nixtract
    ];

    imports = [inputs.nix-index-database.homeModules.nix-index];

    programs = {
      nix-index = {
        enable = true;
        enableZshIntegration = true;
      };

      nix-index-database.comma.enable = true;
      nix-search-tv.enable = true;
    };
  };

  our.nix-config.includes = [a.nixtools];
}
