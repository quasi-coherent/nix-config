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
    schema.user = {
      classes = lib.mkDefault [ "homeManager" ];
      includes = [ den.batteries.mutual-provider ];
    };

    default = {
      homeManager.home.stateVersion = lib.mkDefault "26.05";
      darwin.system.stateVersion = lib.mkDefault 6;

      includes = [
        den.batteries.define-user
        den.batteries.hostname
        den.batteries.inputs'
        den.batteries.self'
      ];
    };

    hosts.aarch64-darwin.hemlock.users.daniel = { };
    homes.aarch64-darwin."daniel@hemlock" = { };
  };
}
