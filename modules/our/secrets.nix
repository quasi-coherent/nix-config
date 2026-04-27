{ inputs, ... }:
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  our.secrets.homeManager =
    { config, pkgs, ... }:
    let
      sops-get = pkgs.callPackage ./_secrets/sops-get.nix { };
    in
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      home.packages = [
        pkgs.age
        pkgs.sops
        sops-get
      ];

      sops = {
        age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
        age.sshKeyPaths = [ ];
        age.generateKey = false;
        defaultSopsFile = ./secrets.yaml;
        validateSopsFiles = true;
        secrets = {
          "hello" = { };
          "id_ed25519" = {
            path = "${config.home.homeDirectory}/.ssh/id_ed25519";
          };
          "signing_ed25519" = {
            path = "${config.home.homeDirectory}/.ssh/signing_ed25519";
          };
          "cachix_auth_token" = { };
          "lichess_oauth_token" = { };
        };
        templates = {
          "CACHIX_AUTH_TOKEN".content = ''"${config.sops.placeholder.cachix_auth_token}"'';
        };
      };
    };
}
