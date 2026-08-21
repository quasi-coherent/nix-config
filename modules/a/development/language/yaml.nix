{ a, ... }:
{
  a.yaml.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        yaml-language-server
        yamlfmt
        yamllint
      ];
    };

  our.nix-config.includes = [ a.yaml ];
}
