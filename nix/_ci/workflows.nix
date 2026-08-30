_:
let
  checkout = {
    name = "checkout";
    uses = "actions/checkout@v6";
  };
  concurrency = {
    cancelInProgress = true;
    group = "\${{ github.workflow }}-\${{ github.head_ref || github.ref_name }}";
  };
  flake-update = {
    name = "flake-update";
    uses = "./.github/actions/flake-update";
    with_ = {
      ghPersonalAccessToken = "\${{ secrets.GH_PAT }}";
      gitPgpPassphrase = "\${{ secrets.PGP_PASSPHRASE }}";
      gitPgpPrivateKey = "\${{ secrets.PGP_PRIVATE_KEY }}";
    };
  };
  flakeRef = "git+file:.";
  setup = {
    name = "setup";
    uses = "./.github/actions/setup";
    with_ = {
      cachixAuthToken = "\${{ secrets.CACHIX_AUTH_TOKEN }}";
    };
  };
  workflows = {
    cd = {
      inherit concurrency;
      jobs.flake-update = {
        name = "flake-update";
        runsOn = "ubuntu-latest";
        steps = [
          checkout
          setup
          flake-update
        ];
      };
      name = "cd";
      on = {
        schedule = [ { cron = "0 0 * * 0"; } ];
        workflowDispatch = { };
      };
      permissions = {
        contents = "write";
        pull-requests = "write";
      };
    };

    ci = {
      inherit concurrency;
      jobs.flake-check = {
        name = "flake check";
        runsOn = "macos-26";
        steps = [
          checkout
          setup
          {
            name = "flake-check";
            run = ''
              nix flake check -Lv ${flakeRef}
              nix flake show
            '';
          }
        ];
        timeoutMinutes = 30;
      };
      name = "ci";
      on = {
        pullRequest = {
          branches = [ "master" ];
        };
        push = {
          branches = [ "master" ];
        };
      };
    };
  };
in
{
  inherit workflows;
}
