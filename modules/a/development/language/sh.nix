{a, ...}: {
  a.bash.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.bash-language-server];
  };

  our.nix-config.includes = [a.bash];
}
