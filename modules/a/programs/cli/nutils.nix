{ a, ... }:
{
  our.nix-config.includes = [ a.nutils ];

  # Network CLI utils.
  a.nutils.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        aria2
        dnsutils
        gping
        grpcurl
        ipcalc
        iperf3
        nmap
        tcpdump
      ];
    };
}
