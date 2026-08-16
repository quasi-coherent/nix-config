{
  lib,
  den,
  inputs,
  ...
}: {
  imports = [
    (inputs.den.namespace "a" true)
    (inputs.den.namespace "our" true)
    (inputs.den.namespace "my" false)
    inputs.den.flakeModules.default
  ];

  den = {
    default = {
      includes = [
        den.batteries.define-user
        den.batteries.hostname
        den.batteries.inputs'
        den.batteries.self'
      ];
    };

    schema.user = {
      classes = lib.mkDefault ["homeManager"];
      includes = [den.batteries.mutual-provider];
    };
  };
}
