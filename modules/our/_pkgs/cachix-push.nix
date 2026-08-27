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
    key="cachix_auth_token"
    args=()

    while [[ $# -gt 0 ]]; do
      case "$1" in
        -k|--key) key="$2"; shift 2     ;;
        -c|--cache) cache="$2"; shift 2 ;;
        --) shift; args+=("$@"); break  ;;
        *) echo "Usage: cachix-push [-k | --key <name>] [-c | --cache <name>] -- <command>" >&2; exit 1 ;;
      esac
    done

    CACHIX_AUTH_TOKEN=$(sops-get -a "$key") cachix watch-exec "$cache" -- "''${args[@]}"
  '';
}
