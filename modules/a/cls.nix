{
  a,
  den,
  lib,
  ...
}:
{
  a.cls.includes = [ a.nixpkgs ];

  a.nixpkgs =
    { class, aspect-chain }:
    den.batteries.forward {
      each = [ class ];
      fromClass = _: "nixpkgs";
      intoClass = { class, ... }: class;
      intoPath = _: [ "nixpkgs" ];
      fromAspect = _: lib.head aspect-chain;
      adaptArgs = lib.id;
    };
}
