{ inputs, ... }:
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  our.secrets.homeManager =
    { config, pkgs, ... }:
    {
      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      home.packages = [
        pkgs.age
        pkgs.sops
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
          "github_actions_ed25519" = { };
          "github_personal_access_token" = { };
          "cachix_auth_token" = { };
          "cratesio_api_token" = { };
          "lichess_oauth_token" = { };
          "anthropic_api_key" = { };
          "openai_api_key" = { };
          "cloudflared_token" = { };
          "gh_cachix" = { };
          "gh_limavm_cachix" = { };
        };
        templates = {
          "CACHIX_AUTH_TOKEN".content = ''"${config.sops.placeholder.cachix_auth_token}"'';
          "CARGO_REGISTRY_TOKEN".content = ''"${config.sops.placeholder.cratesio_api_token}"'';
          "GITHUB_API_TOKEN".content = ''"${config.sops.placeholder.github_personal_access_token}"'';
        };
      };
    };
}
