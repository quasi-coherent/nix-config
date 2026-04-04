{
  den,
  lib,
  inputs,
  ...
}:
{
  imports = [
    (inputs.den.namespace "a" true)
    (inputs.den.namespace "our" true)
  ];

  den = {
    ctx.user.includes = [ den._.mutual-provider ];
    schema.user.classes = lib.mkDefault [ "homeManager" ];

    default = {
      homeManager.home.stateVersion = lib.mkDefault "26.05";
      darwin.system.stateVersion = lib.mkDefault 6;

      includes = [
        den._.define-user
        den._.hostname
        den._.inputs'
        den._.self'
      ];
    };

    hosts.aarch64-darwin.hemlock.users.daniel = { };
    homes.aarch64-darwin."daniel@hemlock" = { };
  };
}
