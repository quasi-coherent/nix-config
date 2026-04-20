#!/usr/bin/env bash

source colors.sh

item_style=(
    background.color="$(get_color GREY 20)"
    background.corner_radius=12
    background.height=28
    background.drawing=on
    background.padding_left=0
    background.padding_right=0
)

add_batt_item() {
    local side="${1:-left}"

    sketchybar --add item "batt" "$side" \
        --set "batt" \
            "${item_style[@]}" \
            icon.color="$(get_color GREY 100)" \
            label.color="$(get_color GREY 100)" \
            icon.padding_left=4 \
            icon.padding_right=0 \
            label.padding_left=0 \
            label.padding_right=4 \
            script="battery.sh" \
            click_script="open /System/Library/PreferencePanes/Battery.prefPane"
}

add_datetime_item() {
    local side="${1:-right}"

    # Create different item names based on position
    local item_name="datetime"
    if [ "$side" == "center" ] || [ "$side" == "e" ] || [ "$side" == "q" ]; then
	item_name="datetime_center"
    fi

    # Date and Time combined in one item
    sketchybar --add item "$item_name" "$side" \
	       --set "$item_name" \
	       "${item_style[@]}" \
	       icon="󰃰" \
	       icon.drawing=off \
	       label="Loading..." \
	       update_freq=30 \
	       script="datetime.sh" \
	       click_script="open -a 'Notion Calendar.app'"

    # Subscribe to time changes
    sketchybar --subscribe "$item_name" system_woke
}

add_net_item() {
    local side="${1:-left}"
    local net_width=76
    local net_style=(
        icon="􂙪"
        icon.drawing=on
        icon.font="$FONT:Italics:10"
        icon.color="$(get_color GREY 80)"
        label.drawing=on
        label='0000.00'
        label.font="$FONT:Semibold:10"
        width=0
        padding_left=-$((net_width - 8))
        label.padding_left=0
        label.padding_right=0
        icon.padding_left=0
        icon.padding_right=4
    )
    NET_LOCATION=$(networksetup -getcurrentlocation)
    if [ "$NET_LOCATION" = "Isolated" ]; then
        NET_LABEL="􀑓"
    else
        NET_LABEL=""
    fi
    tx=("y_offset=7" "${net_style[@]}")
    rx=("y_offset=-6" "${net_style[@]}")

    sketchybar \
        --add item "net" "$side" \
        --set "net" \
        "${item_style[@]}" \
        label="$NET_LABEL" \
        label.drawing=on \
        label.padding_left=5 \
        label.color="$(get_color RED 80)" \
        width=$net_width \
        update_freq=1 \
        script="network_stats.sh" \
        click_script="toggle_airplane.sh" \
        --add item "net.tx" "$side" \
        --set "net.tx" \
        "${tx[@]}" \
        --add item "net.rx" "$side" \
        --set "net.rx" \
        "${rx[@]}"
}

add_notifs_item() {
    local side="${1:-right}"

    # Main notification center anchor/container
    sketchybar --add item notifs.anchor "$side" \
               --set notifs.anchor \
               "${item_style[@]}" \
               icon="󰂚" \
               icon.font="$FONT:Bold:24.0" \
               icon.color="$(get_color BLUE 60)" \
               label.drawing=off \
               background.color="$(get_color GREY 20)" \
               background.corner_radius=12 \
               background.height=28 \
               icon.padding_left=8 \
               icon.padding_right=8 \
               padding_right=4 \
               script="notifications.sh" \
               click_script="open /System/Library/PreferencePanes/Notifications.prefpane" \
               update_freq=4

    # Subscribe to events for dynamic updates
    sketchybar --subscribe notifs.anchor system_woke
}

add_public_item() {
    local side="${1:-left}"

    sketchybar --add item "public" "$side" \
               --set "public" \
               "${item_style[@]}" \
               label="0.0.0.0" \
               icon.color="$(get_color YELLOW 100)" \
               update_freq=600 \
               script="get_public_ip.sh" \
               click_script="open /System/Library/PreferencePanes/Network.prefpane" \
               --subscribe "public" wifi_change
}

add_weather_item() {
    local side="${1:-left}"

    sketchybar --add alias "WeatherMenu,Item-0" "$side" \
               --rename "WeatherMenu,Item-0" "weather" \
               --set "weather" \
               "${item_style[@]}" \
               icon.drawing=off \
	       label.drawing=off \
               script="weather.sh" \
               click_script="open -a Weather"
}
