{ a, ... }:
{
  a.programs.files.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        cosign
        graphviz # graph file tools
        jless
        minisign
        ouch # compression/decompression
        pandoc
        pandoc-imagine
        pandoc-ext-diagram
        pandoc-lua-filters
        snappy
        yq
      ];

      programs = {
        feh.enable = true; # image viewer/cataloguer
        jq.enable = true;
      };
    };

  our.nix-config.includes = [ a.programs.files ];
}
