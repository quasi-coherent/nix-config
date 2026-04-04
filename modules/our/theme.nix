{
  den,
  inputs,
  ...
}:
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs.flake-parts.follows = "flake-parts";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # The stylix theme is automatically enabled where compatible.
  our.theme = {
    includes = [ (den._.unfree [ "spicetify-nix" ]) ];

    darwin =
      { pkgs, ... }:
      {
        imports = [ inputs.stylix.darwinModules.stylix ];

        environment.systemPackages = [ pkgs.fontconfig ];
        fonts.packages = [ pkgs.nerd-fonts.hasklug ];

        stylix = {
          base16Scheme = ./config/base16-scheme.yaml;
          enable = true;
          autoEnable = true;
          polarity = "dark";
          opacity.popups = 0.5;
          fonts = {
            sizes.terminal = 11;
            sizes.applications = 11;
            serif = {
              package = pkgs.nerd-fonts.hasklug;
              name = "Hasklug Nerd Font";
            };
            sansSerif = {
              package = pkgs.nerd-fonts.hasklug;
              name = "Hasklug Nerd Font";
            };
          };
        };
      };
  };
}
