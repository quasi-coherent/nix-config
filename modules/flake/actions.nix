{ inputs, ... }:
let
  # Actions reference.
  actions = {
    checkout = "actions/checkout@v6";
    cachix = "cachix/cachix-action@v17";
    install-nix = "cachix/install-nix-action@v30";
  };

  # Step definitions.
  steps = {
    checkout = {
      uses = actions.checkout;
    };

    install-nix = {
      uses = actions.install-nix;
      "with".nix_path = "nixpkgs=channel:nixos-unstable";
    };

    cachix = {
      uses = actions.cachix;
      "with" = {
        name = "quasi-coherent";
        authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
      };
    };

    # Helper to make a nix-fast-build step for a flake attribute expression.
    nix-fast-build = flakeAttr: {
      name = "nix-fast-build";
      run = "nix run '${flakeRef}#nix-fast-build' -- --no-nom --skip-cached --retries=3 --option accept-flake-config true --flake='${flakeRef}#${flakeAttr}'";
    };
  };

  setupSteps = [
    steps.checkout
    steps.install-nix
    steps.cachix
  ];

  flakeRef = "git+file:.";
in
  {
    flake-file.inputs = {
      actions-nix = {
        url = "github:nialov/actions.nix";
        inputs = {
          nixpkgs.follows = "nixpkgs";
          flake-parts.follows = "flake-parts";
        };
      };
    };

    imports = [ inputs.actions-nix.flakeModules.default ];

    flake.actions-nix = {
      defaultValues.jobs = {
        timeout-minutes = 60;
        runs-on = "ubuntu-24.04";
      };

      workflows = {
        ".github/workflows/ci.yaml" = {
          name = "ci";

          on = {
            push.branches = [ "master" ];
            pull_request = { };
            workflow_dispatch = { };
          };

          concurrency = {
            group = "ci-\${{ github.head_ref || github.ref_name }}";
            cancel-in-progress = "\${{ github.event_name == 'pull_request' }}";
          };

          permissions = { };

          jobs = {
            flake-check = {
              name = "flake check";
              steps = setupSteps ++ [
                {
                  name = "nix flake check";
                  run = "nix flake check '${flakeRef}'";
                }
                {
                  name = "nix flake show";
                  run = "nix flake show '${flakeRef}'";
                }
              ];
            };
          };
        };
      };
    };
  }
