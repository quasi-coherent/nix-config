{ inputs, ... }:
{
  our.secrets.homeManager =
    {
      config,
      pkgs,
      ...
    }:
    let
      cachix-push = pkgs.callPackage ./_pkgs/cachix-push.nix { inherit sops-get; };
      sops-get = pkgs.callPackage ./_pkgs/sops-get.nix { };
    in
    {
      home.packages = [
        pkgs.age
        pkgs.sops
        sops-get
        cachix-push
      ];

      imports = [ inputs.sops-nix.homeManagerModules.sops ];

      sops = {
        age = {
          generateKey = false;
          keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
          sshKeyPaths = [ ];
        };

        defaultSopsFile = ./secrets.yaml;

        secrets = {
          "anthropic_api_key" = { };
          "cachix_auth_token" = { };
          "cloudflared_token" = { };
          "cratesio_api_token" = { };
          "gh_cachix" = { };
          "gh_limavm_cachix" = { };
          "github_actions_ed25519" = { };
          "github_actions_pgp_passphrase" = { };
          "github_actions_pgp_private_key" = { };
          "github_personal_access_token" = { };
          "hello" = { };

          "id_ed25519" = {
            path = "${config.home.homeDirectory}/.ssh/id_ed25519";
          };

          "lichess_oauth_token" = { };
          "openai_api_key" = { };

          "signing_ed25519" = {
            path = "${config.home.homeDirectory}/.ssh/signing_ed25519";
          };
        };

        templates = {
          "CACHIX_AUTH_TOKEN".content = ''"${config.sops.placeholder.cachix_auth_token}"'';
          "CARGO_REGISTRY_TOKEN".content = ''"${config.sops.placeholder.cratesio_api_token}"'';
          "GITHUB_API_TOKEN".content = ''"${config.sops.placeholder.github_personal_access_token}"'';
        };

        validateSopsFiles = true;
      };
    };
}
