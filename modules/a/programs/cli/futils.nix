{ a, ... }:
{
  our.nix-config.includes = [ a.futils ];

  # File CLI utils.
  a.futils.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ouch
        parquet-tools
        snappy
        tree-sitter
      ];
    };
}
