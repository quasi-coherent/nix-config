
colors=(
    BLACK=0x131213
    ASH=0x2f1823
    GREY=0x472234
    WHITE=0xffbee3
    RED=0x74af68
    GREEN=0xf15c99
    LIME=0x81506a
    DARK_GREEN=0x632227
    BLUE=0xff3242
    LIGHT_BLUE=0xff9153
    YELLOW=0x87d75f
    LIGHT_YELLOW=0x9ddf69
    PURPLE=0x5fafd7
    ORANGE=0xffd75f
    MAGENTA=0x9413e5
    SKY=0x7f2121

    TRANSPARENT=0x00000000
    TEXT=0xffcee0d2
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
