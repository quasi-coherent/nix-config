{ a, ... }:
{
  our.nix-config.includes = [ a.yaml ];

  a.yaml.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        yaml-language-server
        yamlfmt
        yamllint
      ];
    };
}
