{ a, ... }:
{
  our.nix-config.includes = [ a.yazi ];

  a.yazi.homeManager = {
    programs.yazi.enable = true;
    programs.yazi.enableZshIntegration = true;
  };
}
