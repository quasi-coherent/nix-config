{
  lib,
  a,
  den,
  ...
}:
{
  a = {
    cls.includes = [ a.nixpkgs ];

    nixpkgs =
      {
        aspect-chain,
        class,
      }:
      den.batteries.forward {
        adaptArgs = lib.id;
        each = [ class ];
        fromAspect = _: lib.head aspect-chain;
        fromClass = _: "nixpkgs";
        intoClass = { class, ... }: class;
        intoPath = _: [ "nixpkgs" ];
      };
  };
}
