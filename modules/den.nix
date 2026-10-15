{
  lib,
  den,
  inputs,
  ...
}:
{
  imports = [
    (inputs.den.namespace "a" true)
    (inputs.den.namespace "our" false)
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

    quirks = {
      nixpkgs-overlays = {
        description = "Overlays for nixpkgs collected from aspects.";
      };
    };

    schema.user = {
      classes = lib.mkDefault [ "homeManager" ];
      includes = [ den.batteries.mutual-provider ];
    };
  };
}
