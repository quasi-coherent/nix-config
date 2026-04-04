{ a, ... }:
{
  our.nix-config.includes = [ a.futils ];

  # File CLI utils.
  a.futils.homeManager =
    { pkgs, ... }:
    let
      extractPkg =
        {
          bzip3,
          gzip,
          gnutar,
          p7zip,
          writeShellApplication,
        }:
        writeShellApplication {
          name = "extract";
          runtimeInputs = [
            bzip3
            gzip
            gnutar
            p7zip
          ];
          text = builtins.readFile ./scripts/extract.sh;
        };
    in
    {
      home.packages = with pkgs; [
        (callPackage extractPkg { })
        parquet-tools
        snappy
        tree-sitter
        unzipNLS
        zip
        zstd
      ];
    };
}
