_: let
  cd = {
    concurrency = {
      cancelInProgress = true;
      group = "\${{ github.workflow }}-\${{ github.head_ref || github.ref_name }}";
    };
    jobs.lockfile = {
      name = "lockfile";
      runsOn = "ubuntu-latest";
      steps = [
        common.steps.checkout
        common.steps.install
        common.steps.lockfile
      ];
    };
    name = "cd";
    on = {
      schedule = [{cron = "0 0 * * 0";}];
      workflowDispatch = {};
    };
    permissions = {
      contents = "write";
      pull-requests = "write";
    };
  };
  ci = {
    concurrency = {
      cancelInProgress = true;
      group = "\${{ github.workflow }}-\${{ github.head_ref || github.ref_name }}";
    };
    jobs.flake-check = {
      name = "flake check";
      runsOn = "macos-26";
      steps = [
        common.steps.checkout
        common.steps.install
        common.steps.cachix
        {
          name = "nix flake check";
          run = "nix flake check -Lv ${flakeRef}";
        }
        {
          name = "nix flake show";
          run = "nix flake show";
        }
      ];
      timeoutMinutes = 30;
    };
    name = "ci";
    on = {
      pullRequest = {
        branches = ["master"];
      };
      push = {
        branches = ["master"];
      };
    };
  };
  common = import ./common.nix {};
  flakeRef = "git+file:.";
in {
  workflows = {inherit ci cd;};
}
