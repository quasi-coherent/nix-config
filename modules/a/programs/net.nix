{ a, ... }:
{
  # CLI programs for networking.
  a.programs.net.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        aria2
        cloudflared
        curl
        curlie
        doggo
        dnsutils
        httpie
        gping
        grpcurl
        ipcalc
        iperf3
        nmap
        tcpdump
        wget
      ];
    };

  our.nix-config.includes = [ a.programs.net ];
}
