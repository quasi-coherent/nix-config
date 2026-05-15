{ inputs, ... }:
let
  # Actions reference.
  actions = {
    checkout = "actions/checkout@v6";
    cachix = "cachix/cachix-action@v17";
    install-nix = "cachix/install-nix-action@v30";
    nix-flake-update = "DeterminateSystems/update-flake-lock@main";
  };

  # Step definitions.
  steps = {
    checkout = {
      uses = actions.checkout;
    };

    install-nix.uses = actions.install-nix;

    cachix = {
      uses = actions.cachix;
      "with" = {
        name = "quasi-coherent";
        authToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
      };
    };

    nix-flake-update = {
      uses = actions.nix-flake-update;
      "with".pr-title = "flake.lock update";
    };

    nix-flake-check = {
      name = "nix flake check";
      run = "nix flake check '${flakeRef}'";
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

  concurrency = {
    group = "\${{ github.workflow }}-\${{ github.head_ref || github.ref_name }}";
    cancel-in-progress = "\${{ github.event_name == 'pull_request' }}";
  };

  flakeRef = "git+file:.";
in
{
  imports = [ inputs.actions-nix.flakeModules.default ];

  flake-file.inputs = {
    actions-nix = {
      url = "github:nialov/actions.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  flake.actions-nix = {
    defaultValues.jobs = {
      timeout-minutes = 60;
      runs-on = "ubuntu-24.04";
    };

    workflows = {
      ".github/workflows/ci.yaml" = {
        inherit concurrency;
        name = "ci";
        on = {
          push.branches = [ "master" ];
          pull_request = { };
          workflow_dispatch = { };
        };
        permissions = { };
        jobs = {
          flake-check = {
            name = "flake check";
            steps = setupSteps ++ [
              steps.nix-flake-check
              {
                name = "nix flake show";
                run = "nix flake show '${flakeRef}'";
              }
            ];
          };
        };
      };

      ".github/workflows/cd.yaml" = {
        inherit concurrency;
        name = "cd";
        on.schedule = [
          { cron = "0 4 * * */5"; }
        ];
        jobs = {
          flake-update = {
            name = "flake update";
            runs-on = "macos-26";
            steps = setupSteps ++ [
              steps.nix-flake-check
              steps.nix-flake-update
            ];
          };
        };
      };
    };
  };
}
