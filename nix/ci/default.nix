{ inputs, ... }:
let
  # Actions reference.
  actions = {
    checkout = "actions/checkout@v6";
    cachix = "cachix/cachix-action@v17";
    install-nix = "cachix/install-nix-action@v30";
    update-flake-lock = "DeterminateSystems/update-flake-lock@main";
  };

  # Step definitions.
  steps = {
    checkout = {
      uses = actions.checkout;
    };

    checkoutBranch = branch: {
      uses = actions.checkout;
      "with".ref = branch;
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

    flake-check = {
      name = "nix flake check";
      run = "nix -Lv flake check '${flakeRef}'";
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
        on.push.branches = [
          "master"
          "unstable"
        ];
        jobs = {
          flake-check = {
            name = "flake check";
            runs-on = "macos-26";
            steps = setupSteps ++ [
              steps.flake-check
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
        on = {
          workflow_dispatch = { };
          schedule = [ { cron = "0 0 * * 0"; } ];
        };
        jobs = {
          flake-update = {
            name = "flake update";
            runs-on = "macos-26";
            permissions = {
              contents = "write";
              pull-requests = "write";
            };
            steps = [
              (steps.checkoutBranch "unstable")
              steps.install-nix
              steps.cachix
              {
                uses = actions.update-flake-lock;
                "with" = {
                  sign-commits = true;
                  gpg-private-key = "\${{ secrets.GH_ACTIONS_SIGNING_KEY }}";
                  commit-msg = "Update flake.lock";
                  branch = "unstable";
                };
              }
            ];
          };
        };
      };
    };
  };
}
