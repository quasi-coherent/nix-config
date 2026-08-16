{inputs, ...}: {
  imports = [
    inputs.github-actions.flakeModules.default
  ];

  perSystem = {
    config,
    pkgs,
    ...
  }: {
    githubActions = {
      inherit (import ./workflows.nix {}) workflows;
      enable = true;
    };

    packages.workflows = pkgs.runCommand "copy-workflows" {} ''
      mkdir -p $out/.github/workflows
      cp -r ${config.githubActions.workflowsDir}/* $out/.github/workflows/
    '';
  };
}
