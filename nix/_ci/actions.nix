_:
let
  actions = {
    flake-update = {
      description = "Update flake.lock and create PR.";
      inputs = {
        ghPersonalAccessToken = {
          description = "GitHub API access token.";
        };
        gitPgpPassphrase = {
          description = "Passphrase of the PGP private key if enabled.";
        };
        gitPgpPrivateKey = {
          description = "PGP private key if enabled.";
        };
      };
      name = "flake-update";
      runs.steps = [
        import-pgp
        {
          env = {
            GH_TOKEN = "\${{ inputs.ghPersonalAccessToken }}";
            GIT_AUTHOR_EMAIL = "\${{ steps.import-pgp.outputs.email }}";
            GIT_AUTHOR_NAME = "\${{ steps.import-pgp.outputs.name }}";
            GIT_COMMITTER_EMAIL = "\${{ steps.import-pgp.outputs.email }}";
            GIT_COMMITTER_NAME = "\${{ steps.import-pgp.outputs.name }}";
          };
          name = "flake-update";
          run = "nix run git+file:.#gh-flake-update";
        }
      ];
    };
    setup = {
      description = "Setup for git, toolchain, and cachix.";
      inputs = {
        cachixAuthToken = {
          description = "Cachix auth token with read/write permissions.";
        };
      };
      name = "setup";
      runs.steps = [
        install-nix
        cachix
      ];
    };
  };
  cachix = {
    name = "cachix";
    uses = "cachix/cachix-action@v17";
    with_ = {
      authToken = "\${{ inputs.cachixAuthToken }}";
      name = "quasi-coherent";
    };
  };
  import-pgp = {
    id = "import-pgp";
    name = "import-pgp";
    uses = "crazy-max/ghaction-import-gpg@2dc316deee8e90f13e1a351ab510b4d5bc0c82cd"; # v7.0.0
    with_ = {
      git_config_global = true;
      git_user_signingkey = true;
      git_commit_gpgsign = true;
      gpg_private_key = "\${{ inputs.gitPgpPrivateKey }}";
      passphrase = "\${{ inputs.gitPgpPassphrase }}";
    };
  };
  install-nix = {
    name = "install-nix";
    uses = "cachix/install-nix-action@v30";
    with_ = {
      nix_path = "nixpkgs=channel:nixos-unstable";
    };
  };
in
{
  inherit actions;
}
