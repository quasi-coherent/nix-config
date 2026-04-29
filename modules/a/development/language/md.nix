{ a, ... }:
{
  our.nix-config.includes = [ a.markdown ];

  a.markdown.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        glow
        marksman
      ];
    };
}
