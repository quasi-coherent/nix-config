{ ... }:
let
  timeZone = "America/New_York";
in
{
  our.timezone = {
    darwin.time = { inherit timeZone; };
    nixos.time = { inherit timeZone; };
  };
}
