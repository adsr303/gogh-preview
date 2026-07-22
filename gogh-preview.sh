#!/usr/bin/env bash

declare -A THEME_COLORS

while read -r PROPERTY_C VALUE REST; do
    PROPERTY="${PROPERTY_C%:*}"
    case "$PROPERTY" in
        color_[01][0-9] | background | foreground | cursor)
            THEME_COLORS+=(["$PROPERTY"]="${VALUE:2:6}")
            ;;
        name)
            THEME_NAME="$VALUE ${REST[*]}" # Making a lot of assumptions here
            THEME_NAME="${THEME_NAME#*\'}"
            THEME_NAME="${THEME_NAME%\'*}"
            ;;
    esac
done

declare -ra COLOR_NAMES=(
    ""
    "black *"
    "red ***"
    "green *"
    "yellow "
    "blue **"
    "magenta"
    "cyan **"
    "white *"
)

color-print() {
    local FG_R="0x${1:0:2}"
    local FG_G="0x${1:2:2}"
    local FG_B="0x${1:4:2}"

    local BG_R="0x${2:0:2}"
    local BG_G="0x${2:2:2}"
    local BG_B="0x${2:4:2}"

    printf "\033[38;2;%d;%d;%d;48;2;%d;%d;%dm%s\033[0m" \
        "$FG_R" "$FG_G" "$FG_B" "$BG_R" "$BG_G" "$BG_B" "$3"
}

color-println() {
    color-print "$@"
    echo
}

declare -r BG="${THEME_COLORS[background]}"
declare -r FG="${THEME_COLORS[foreground]}"

printf -v BLANK "%48s" "" # 3 * (7 + 6 + 3)
declare -r BLANK
printf -v PADDED_NAME "'%s'%*s" "$THEME_NAME" $((30 - ${#THEME_NAME})) ""

color-println "$FG" "$BG" "$BLANK"
color-println "$FG" "$BG" " $ gogh-preview $PADDED_NAME"
color-println "$FG" "$BG" "$BLANK"

for ((i = 1; i <= 8; i++)); do
    printf -v PROPERTY "color_%02d" $i
    FG_T="${THEME_COLORS[$PROPERTY]}"
    COLOR_NAME="${COLOR_NAMES[i]}"
    color-print "$FG_T" "$BG" " $COLOR_NAME $FG_T "
    color-print "$BG" "$FG_T" " $COLOR_NAME $FG_T "
    printf -v PROPERTY "color_%02d" $((i + 8))
    FG_T="${THEME_COLORS[$PROPERTY]}"
    color-print "$FG_T" "$BG" " $COLOR_NAME $FG_T "
    echo
done

color-println "$FG" "$BG" "$BLANK"
color-print "${THEME_COLORS[foreground]}" "$BG" ' $ '
color-print "${THEME_COLORS[cursor]}" "$BG" $'\u2588'"${BLANK:0:44}"
echo
color-println "$FG" "$BG" "$BLANK"
