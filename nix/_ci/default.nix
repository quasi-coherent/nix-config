{ inputs, ... }:
{
  imports = [
    inputs.github-actions.flakeModules.default
  ];

  perSystem =
    {
      config,
      pkgs,
      ...
    }:
    {
      githubActions = {
        inherit (import ./workflows.nix { }) workflows;
        inherit (import ./actions.nix { }) actions;
        enable = true;
      };

      packages = {
        dot-github = pkgs.runCommand "dot-github" { } ''
          mkdir -p $out/.github/actions
          mkdir -p $out/.github/workflows
          cp -r ${config.githubActions.actionsDir}/* $out/.github/actions/
          cp -r ${config.githubActions.workflowsDir}/* $out/.github/workflows/
        '';

        gh-flake-update = pkgs.callPackage ./_pkgs/gh-flake-update.nix { };
      };
    };
}
