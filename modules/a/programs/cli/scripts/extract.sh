help() {
  echo
  echo "Extract an archive."
  echo "USAGE: extract [ARCHIVE]"
  echo
  echo "POSITIONAL ARGUMENTS:"
  echo "    <ARCHIVE>"
  echo "        A file archive.  Accepted extensions are:"
  echo "          - *.tar.bz2"
  echo "          - *.tar.gz"
  echo "          - *.bz2"
  echo "          - *.gz"
  echo "          - *.tar"
  echo "          - *.tbz2"
  echo "          - *.tgz"
  echo "          - *.zip"
  echo "          - *.Z"
  echo "          - *.7z"
  echo "          - *.tar.xz"
  echo
}

if [ -f "$1" ] ; then
    case $1 in
        -h|--help) help; exit 0    ;;
        *.tar.bz2) tar xjf "$1"    ;;
        *.tar.gz)  tar xzf "$1"    ;;
        *.bz2)     bunzip2 "$1"    ;;
        *.gz)      gunzip "$1"     ;;
        *.tar)     tar xf "$1"     ;;
        *.tbz2)    tar xjf "$1"    ;;
        *.tgz)     tar xzf "$1"    ;;
        *.zip)     unzip "$1"      ;;
        *.Z)       uncompress "$1" ;;
        *.7z)      7z x "$1"       ;;
        *.tar.xz)  tar xf "$1"     ;;
        *)
            echo "Unknown format '$1'"
            help
            exit 1
            ;;
    esac
else
    echo "'$1' is not a valid file"
    help
    exit 1
fi
