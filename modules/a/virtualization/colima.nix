{ a, ... }:
{
  # flake-file.inputs.lima = {
  #   url = "github:nixos-lima/nixos-lima";
  #   inputs.nixpkgs-unstable.follows = "nixpkgs";
  # };

  our.nix-config.includes = [ a.colima ];

  a.colima.homeManager =
    { config, ... }:
    {
      services.colima = {
        enable = true;
        colimaHomeDir = "${config.xdg.configHome}/colima";
      };
    };
}
