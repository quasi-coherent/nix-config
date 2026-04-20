{ a, ... }:
{
  our.nix-config.includes = [ a.gpg ];

  a.gpg.homeManager
    = { pkgs, ... }:
    {
      programs.gpg.enable = true;
      services.gpg-agent.enable = true;
      services.gpg-agent = {
        pinentry.package = pkgs.pinentry-tty;
        enableZshIntegration = true;
        defaultCacheTtl = 86400;
      };
  };
}
