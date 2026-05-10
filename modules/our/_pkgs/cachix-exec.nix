{
  cachix,
  sops-get,
  lib,
  writeShellApplication,
}:
writeShellApplication {
  name = "cachix-exec";
  runtimeInputs = [
    "cachix"
    "sops-get"
  ];
  text = ''
    CACHIX_AUTH_TOKEN=$(${lib.getExe sops-get} -a cachix_auth_token) ${lib.getExe cachix} watch-exec quasi-coherent -- "$@"
  '';
}
