{ a, den, ... }:
{
  our.nix-config.includes = [ a.desktop ];

  a.desktop = {
    includes = [
      (den.batteries.unfree [ "slack" ])
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          slack
          slack-cli
        ];
        programs.element-desktop.enable = true;
      };
  };
}
