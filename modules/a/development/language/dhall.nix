{a, ...}: {
  a.dhall.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      dhall
      dhall-json
      dhall-lsp-server
      dhall-yaml
    ];
  };

  our.nix-config.includes = [a.dhall];
}
