{ a, inputs, ... }:
{
  flake-file.inputs = {
    trix = {
      url = "github:aanderse/trix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  our.nix-config.includes = [ a.nixtools ];

  a.nixtools.homeManager =
    { inputs', pkgs, ... }:
    let
      trix = inputs'.trix.packages.trix;
    in
    {
      imports = [ inputs.nix-index-database.homeModules.nix-index ];

      home.packages = [
        trix
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

      programs.nix-index.enable = true;
      programs.nix-index.enableZshIntegration = true;
      programs.nix-index-database.comma.enable = true;
    };
}
