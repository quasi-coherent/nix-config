{ a, ... }:
{
  # Developer CLI utils.
  a.programs.dev = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          asciinema # Terminal session recorder for asciinema.org
          atac # Terminal Postman
          clog-cli # CHANGELOG generator
          gdb
          gdb-dashboard
          grex # Regex generator
          k6 # Load testing
          # BROKEN(2026-08-15): libserdes-8.1.0
          # /nix/store/kgqg99mprxbzlrid51yywkhjg5g88857-avro-c++-1.12.0/include/avro/Exception.hh:37:35: error: no member named 'format' in namespace 'fmt'
          # kcat # CLI Kafka producer/consumer
          otel-cli # CLI to send traces
          otel-desktop-viewer # Local collector with UI
          rainfrog # TUI psql client
          scc # Sloc, cloc
          steampipe # Query APIs with SQL
          tree-sitter # Developing tree-sitter parsers
        ];
      };
  };

  our.nix-config.includes = [ a.programs.dev ];
}
