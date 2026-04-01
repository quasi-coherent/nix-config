{ __findFile, ... }:
{
  my.user = {
    includes = [
      <a/direnv>
      <a/nix>

      <den/primary-user>
      (<den/user-shell> "zsh")

      <our/nix-index>
      <our/nix-registry>
      <our/terminal>
    ];
  };

  den.aspects.dmdmd.includes = [ <my/user> ];
}
