{
  cachix,
  config,
  lib,
  writeShellApplication,
}:
writeShellApplication {
  name = "cachix-exec";
  text = ''
    CACHIX_AUTH_TOKEN=${config.sops.templates."CACHIX_AUTH_TOKEN".path} \
      ${lib.getBin cachix}/bin/cachix watch-exec quasi-coherent -- "$@"
  '';
}
