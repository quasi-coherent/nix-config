{
  a,
  inputs,
  ...
}:
{
  a.homebrew.darwin =
    { config, ... }:
    {
      homebrew = {
        casks = [
          "linear"
          "orion"
          "slack"
        ];

        enable = true;
        enableZshIntegration = true;

        onActivation = {
          autoUpdate = false;
          # We are managing packages installed by Homebrew here, so
          # remove anything that's in Homebrew but not in the generated Brewfile.
          cleanup = "zap";
        };
      };

      imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

      nix-homebrew = {
        enable = true;
        # Rosetta has to be installed outside of nix-darwin:
        #   `softwareupdate --install-rosetta --agree-to-license`
        enableRosetta = true;
        user = config.system.primaryUser;
      };
    };

  our.nix-config.includes = [ a.homebrew ];
}
