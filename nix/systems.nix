{
  lib,
  den,
  ...
}: {
  systems = lib.attrNames den.hosts;
}
