{ a, ... }:
{
  our.nix-profile.includes = [ a.desktop ];

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
