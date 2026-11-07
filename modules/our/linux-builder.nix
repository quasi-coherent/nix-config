{ inputs, ... }:
{
  our.linux-builder.darwin = {
    imports = [ inputs.nix-rosetta-builder.darwinModules.default ];

    # This depends on having `rosetta` installed, which must be done outside of
    # nix:
    # ```
    # softwareupdate --install-rosetta --agree-to-license
    # ```
    nix-rosetta-builder.onDemand = true;
  };
}
