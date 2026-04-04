{ a, ... }:
{
  our.nix-config.includes = [ a.dhall ];

  a.dhall.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        dhall
        dhall-json
        dhall-lsp-server
        dhall-yaml
      ];
    };
}
