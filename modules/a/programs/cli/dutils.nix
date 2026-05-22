{ a, den, ... }:
{
  our.nix-config.includes = [ a.dutils ];

  # Developer CLI utils.
  a.dutils = {
    includes = [
      (den.batteries.unfree [ "claude-code" ])
    ];

    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          asciinema
          atac # Terminal Postman
          claude-code
          clog-cli
          gdb
          gdb-dashboard
          grex # Regex generator
          k6 # Load testing
          kcat # CLI Kafka producer/consumer
          otel-cli # CLI to send traces
          otel-desktop-viewer # Local collector with UI
          rainfrog # TUI psql client
          steampipe # Query APIs with SQL
        ];
      };
  };
}
