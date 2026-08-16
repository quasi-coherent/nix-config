{a, ...}: {
  a.python.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      # BROKEN(2026-08-15): fails its own test suite...
      # python314Packages.python-lsp-ruff
      ruff
    ];
  };

  our.nix-config.includes = [a.python];
}
