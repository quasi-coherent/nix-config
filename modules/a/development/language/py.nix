{ a, ... }:
{
  our.nix-config.includes = [ a.python ];

  a.python.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        python314Packages.python-lsp-ruff
        ruff
      ];
    };
}
