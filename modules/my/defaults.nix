{ den, lib, ... }:
{
  den = {
    ctx.user.includes = [ den._.mutual-provider ];

    default = {
      homeManager.home.stateVersion = lib.mkDefault "26.05";
      darwin.system.stateVersion = lib.mkDefault 6;

      includes = [
        den.provides.define-user
        den.provides.hostname
        den.provides.inputs'
        den.provides.self'
      ];
    };

    schema.user.classes = lib.mkDefault [ "homeManager" ];
    schema.user.userName = lib.mkDefault "danieldonohue";
  };
}
