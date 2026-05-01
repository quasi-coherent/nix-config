{ a, den, ... }:
{
  our.nix-config.includes = [
    a.desktop
    (den._.unfree [ "1password" "1password-cli" "slack" ])
  ];

  a.desktop.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        _1password-gui
        _1password-cli
        slack
        slack-cli
      ];

      programs.element-desktop.enable = true;
    };
}
