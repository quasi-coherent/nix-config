{
  lib,
  cachix,
  sops-get,
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

    cache="quasi-coherent"
    args=()

    while [[ $# -gt 0 ]]; do
      case "$1" in
        -c|--cache) cache="$2"; shift 2 ;;
        --) shift; args+=("$@"); break ;;
        *) echo "Usage: cachix-push [-c/--cache <CACHE>] -- [COMMAND]" >&2; exit 1 ;;
      esac
    done

    CACHIX_AUTH_TOKEN=$(sops-get -a cachix_auth_token) cachix watch-exec "$cache" -- "''${args[@]}"
  '';
}
