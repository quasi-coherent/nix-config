{ inputs, ... }:
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ ./_secrets/sops-get.nix ];

  our.secrets.homeManager =
    { config, ... }:
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
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
        };
        templates = {
          "CACHIX_AUTH_TOKEN".content = ''
            export CACHIX_AUTH_TOKEN="${config.sops.placeholder.cachix_auth_token}"
          '';
        };
      };
    };
}
