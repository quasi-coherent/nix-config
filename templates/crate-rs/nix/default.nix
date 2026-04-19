{ inputs, ... }:
{
  imports = [
    inputs.treefmt.flakeModule.default

    ./formatter.nix
    ./crate-rs.nix
  ];
}
