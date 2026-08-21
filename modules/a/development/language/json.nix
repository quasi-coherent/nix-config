{ a, ... }:
{
  a.json.homeManager =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.vscode-json-languageserver ];
    };

  our.nix-config.includes = [ a.json ];
}
