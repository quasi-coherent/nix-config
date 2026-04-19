export PADDINGS_SMALL=4
export PADDINGS=8
export PADDINGS_LARGE=16

FONT="Hasklug Nerd Font"

source colors.sh

##### Bar background appearance
bar_config=(
    blur_radius=0
    color=$(get_color TRANSPARENT)
    corner_radius=0
    height=38
    margin=10
    notch_width=200
    padding_left=0
    padding_right=0
    position=top
    shadow=off
    sticky=on
    topmost=window
    y_offset=5
)

icon_defaults=(
    icon.color="$(get_color TEXT 100)"
    icon.font="$FONT:Bold:16.0"
    icon.padding_left=$PADDINGS
    icon.padding_right=0
)

label_defaults=(
    label.color="$(get_color TEXT 100)"
    label.font="$FONT:Semibold:13.0"
    label.padding_left=$PADDINGS
    label.padding_right=$PADDINGS
)

background_defaults=(
    background.corner_radius=9
    background.height=30
    background.padding_left="$PADDINGS"
    background.padding_right="$PADDINGS"
)

popup_defaults=(
    popup.height=30
    popup.horizontal=off
    popup.background.border_color="$(get_color LIME 80)"
    popup.background.border_width=2
    popup.background.color="$(get_color ASH 80)"
    popup.background.corner_radius=11
    popup.background.shadow.drawing=on
)

item_style=(
    background.color="$(get_color GREY 20)"
    background.corner_radius=12
    background.height=28
    background.drawing=on
    background.padding_left=0
    background.padding_right=0
)

# Setting up general bar appearance and defaults
sketchybar --bar "${bar_config[@]}" \
	   --default \
	   updates=when_shown \
	   "${icon_defaults[@]}" \
	   "${label_defaults[@]}" \
	   "${background_defaults[@]}" \
	   "${popup_defaults[@]}"

##### Left area items
LEFT_AREA=(
    "batt"
    "public"
    "net"
)

CENTER_AREA=(
    "datetime"
)

##### Right area items
RIGHT_AREA=(
    "weather"
    "datetime"
    "notifs"
)

##### Load items
for item in "${LEFT_AREA[@]}"; do
    source "${item}-item.sh"
    add_${item}_item left
done

for item in "${CENTER_AREA[@]}"; do
    source "${item}-item.sh"
    add_${item}_item center
done

for item in "${RIGHT_AREA[@]}"; do
    source "${item}-item.sh"
    add_${item}_item right
done

##### Force all scripts to run the first time #####
sketchybar --update
