{ a, den, ... }:
{
  our.nix-config.includes = [
    a.dutils
    (den._.unfree [ "claude-code" ])
  ];

  # Developer CLI utils.
  a.dutils.homeManager =
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
}
