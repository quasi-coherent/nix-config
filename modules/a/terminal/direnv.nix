{ a, ... }:
{
  our.nix-config.includes = [ a.direnv ];

  a.direnv.homeManager = {
    programs.direnv.enable = true;

    programs.direnv = {
      enableZshIntegration = true;
      nix-direnv.enable = true;
      silent = true;
    };
  };
}
