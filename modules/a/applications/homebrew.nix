{ a, inputs, ... }:
{
  flake-file.inputs.nix-homebrew.url = "github:zhaofengli/nix-homebrew";

  our.nix-config.includes = [ a.homebrew ];

  a.homebrew.darwin =
    { config, ... }:
    {
      imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

      homebrew.enable = true;
      homebrew.enableZshIntegration = true;
      homebrew.onActivation = {
        autoUpdate = false;
        # We are managing packages installed by Homebrew here, so
        # remove anything that's in Homebrew but not in the generated Brewfile.
        cleanup = "zap";
      };
      homebrew.casks = [
        "1password"
        "1password-cli"
        "orion"
        "slack"
      ];

      nix-homebrew = {
        enable = true;
        # Rosetta has to be installed outside of nix-darwin:
        #   `softwareupdate --install-rosetta --agree-to-license`
        enableRosetta = true;
        user = config.system.primaryUser;
      };
    };
}
