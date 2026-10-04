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
      dirHashes = {
        description = "Attribute set of zsh local directory hashes.";
      };
      shellAliases = {
        description = "Attribute set of alias/shell command.";
      };
      siteFunctions = {
        description = "Attribute set of shell function name/body.";
      };
    };
    schema.user = {
      classes = lib.mkDefault [ "homeManager" ];
      includes = [ den.batteries.mutual-provider ];
    };
  };
}
