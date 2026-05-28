{
  cachix,
  sops-get,
  lib,
  writeShellApplication,
}:
writeShellApplication {
  name = "cachix-push";
  runtimeInputs = [
    cachix
    sops-get
  ];
  text = ''
    export PATH=${
      lib.makeBinPath [
        sops-get
        cachix
      ]
    }:$PATH
    CACHIX_AUTH_TOKEN=$(sops-get -a cachix_auth_token) cachix watch-exec quasi-coherent -- "$@"
  '';
}
