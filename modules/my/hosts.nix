{ __findFile, ... }:
{
  den.aspects.hemlock.includes = [ <my/machine/base> ];

  my.machine.provides = {
    base.includes = [
      <den/hostname>

      <our/nix-settings>
    ];
  };
}
