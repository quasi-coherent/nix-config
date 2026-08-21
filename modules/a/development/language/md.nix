{ a, ... }:
{
  a.markdown.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        glow
        marksman
      ];
    };

  our.nix-config.includes = [ a.markdown ];
}
