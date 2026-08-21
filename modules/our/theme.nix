{ inputs, ... }:
{
  # The stylix theme is automatically enabled where compatible.
  our.theme = {
    homeManager =
      { pkgs, ... }:
      {
        fonts.fontconfig.enable = true;

        home.packages = [
          pkgs.beedii
          pkgs.nerd-fonts.hasklug
        ];
      };

    darwin =
      { pkgs, ... }:
      {
        imports = [ inputs.stylix.darwinModules.stylix ];

        stylix = {
          autoEnable = true;
          base16Scheme = ./base16-scheme.yaml;
          enable = true;

          fonts = {
            emoji = {
              name = "Beedii Emoji";
              package = pkgs.beedii;
            };

            monospace = {
              name = "Hasklug Nerd Font Mono";
              package = pkgs.nerd-fonts.hasklug;
            };

            sansSerif = {
              name = "Hasklug Nerd Font";
              package = pkgs.nerd-fonts.hasklug;
            };

            serif = {
              name = "Hasklug Nerd Font";
              package = pkgs.nerd-fonts.hasklug;
            };

            sizes = {
              applications = 11;
              terminal = 11;
            };
          };

          opacity.popups = 0.5;
          polarity = "dark";
        };
      };
  };
}
