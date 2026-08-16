{a, ...}: {
  a.lean.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.elan];
  };

  our.nix-config.includes = [a.lean];
}
