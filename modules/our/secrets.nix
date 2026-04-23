{ inputs, ... }:
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ ./_secrets/sops-get.nix ];

  our.secrets.homeManager =
    { config, pkgs, self', ... }:
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      home.packages = [
        pkgs.age
        pkgs.sops
        self'.packages.sops-get
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
          "cachix_auth_token" = { };
          "signing_asc" = { };
          "lichess_oauth_token" = { };
        };
        templates = {
          "CACHIX_AUTH_TOKEN".content = ''"${config.sops.placeholder.cachix_auth_token}"'';
        };
      };
    };
}
