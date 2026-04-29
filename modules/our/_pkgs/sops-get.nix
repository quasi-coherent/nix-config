{
  lib,
  sops,
  writeShellApplication,
}:
writeShellApplication {
  name = "sops-get";
  text = ''
    export PATH=${lib.getBin sops}/bin:$PATH
    declare -a args more

    dry=""

    while test -n "''${1:-}"; do
      first="$1"
      shift
      case "$first" in
        --dry-run)
          dry=true
          shift
        ;;
        -a|--attr)
          file="${./..}/secrets.yaml"
          extract="[\"$1\"]"
          shift
        ;;
        *)
          more+=("$first")
        ;;
      esac
    done

    if test -n "$extract"; then
      args+=("--extract" "$extract")
    fi

    args+=("''${more[@]}")

    if test -n "$file"; then
      args+=("$file")
    fi

    if test -n "$dry"; then
      echo "sops decrypt" "''${args[@]}"
      exit 0
    else
      exec sops decrypt "''${args[@]}"
    fi
  '';
}
