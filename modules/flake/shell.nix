{
  inputs,
  lib,
  den,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default =
        let
          system = pkgs.stdenvNoCC.targetPlatform.system;

          denApps = den.lib.nh.denApps {
            outPrefix = [ ];
            fromFlake = false;
          } pkgs;

          formatter = inputs.self.formatter.${system};
          fmtt = pkgs.writeShellApplication {
            name = "fmtt";
            text = ''
              ${lib.getExe formatter} "$@"
            '';
          };
        in
        pkgs.mkShell {
          buildInputs = denApps ++ [
            fmtt
            pkgs.nh
            pkgs.just
            pkgs.cachix
          ];
        };
    };
}
