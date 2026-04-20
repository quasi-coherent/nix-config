
colors=(
    BLUE=0x78c2ff
    LIME=0xb1ff00
    RED=0xffdff1
    GREY=0xbecfdb
    ASH=0xe6e6e6
    GREEN=0xcee0d2
    YELLOW=0xfff7e0
    TRANSPARENT=0x000000
    TEXT=0xcee0d2
)

get_color() {
    local COLOR="$1"
    local OPACITY="${2:-}"

    # find the color value
    local val=""
    for entry in "${colors[@]}"; do
        IFS='=' read -r name value <<< "$entry"
        if [ "$name" = "$COLOR" ]; then
            val="$value"
            break
        fi
    done

    if [ -z "$val" ]; then
        echo "Color $COLOR not found" >&2
        return 1
    fi

    # If no opacity specified, return the full color
    if [ -z "$OPACITY" ]; then
        echo "$val"
        return 0
    fi

    local hexdec=$(( (OPACITY * 255 + 50) / 100 ))
    # Format to two uppercase hex digits
    local hex="${hexdec#0x}" # not strictly needed, just to be safe
    printf -v hex "%02X" "$hexdec"

    # Drop "0x" prefix, drop the first two hex digits (the AA), keep the rest
    # val is "0xAARRGGBB" so:
    local rgb="${val:4}"   # this removes "0xAA" → gives "RRGGBB"

    # Construct new color
    echo "0x${hex}${rgb}"
}
