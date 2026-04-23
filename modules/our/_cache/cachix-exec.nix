{
  perSystem = { config, pkgs, ... }:
  let
    cachix-exec = {
      meta = "Push the output of a command to cachix";
      program = pkgs.writeShellApplication {
        name = "cachix-push";
        text = ''
          CACHIX_AUTH_TOKEN=${config.sops.templates."CACHIX_AUTH_TOKEN".path} \
            ${pkgs.lib.getBin pkgs.cachix} watch-exec quasi-coherent -- "$@"
        '';
      };
    };
  in
    {
      packages.cachix-exec = cachix-exec;
    };
}
