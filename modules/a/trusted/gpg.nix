{a, ...}: {
  a.gpg.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.gnupg];
  };

  our.nix-config.includes = [a.gpg];
}
