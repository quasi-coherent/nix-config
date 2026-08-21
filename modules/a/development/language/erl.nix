{ a, ... }:
{
  a.erlang.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs.beam28Packages; [
        elvis-erlang
        erlang
        erlfmt
        hex
        rebar3
      ];
    };

  our.nix-config.includes = [ a.erlang ];
}
