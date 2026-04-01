{ den, inputs, ... }:
{
  imports = [
    inputs.den.flakeModule
    (inputs.den.namespace "a" true)
    (inputs.den.namespace "my" false)
    (inputs.den.namespace "our" false)
  ];
  _module.args.__findFile = den.lib.__findFile;
}
