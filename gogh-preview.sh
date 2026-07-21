#!/usr/bin/env bash

#curl -s -L https://github.com/Gogh-Co/Gogh/raw/refs/heads/master/themes/Campbell.yml

# Working with stdin for now

declare -A THEME_COLORS

parse-line() {
    local PROPERTY="${1%:*}"
    local VALUE="$2"
    case "$PROPERTY" in
        color_[01][0-9] | background | foreground | cursor)
            THEME_COLORS+=(["$PROPERTY"]="${VALUE:2:6}")
            ;;
    esac
}

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

show() {
    # TODO:
    # 1. Switch to alternate screen \033[?1049h
    # 2. Display theme simulation in the center of the screen
    # 3. Wait for any key press
    IFS='' read -r -n 1 -s
    # 4. Restore normal screen \033[?1049l
    # See https://gist.github.com/ConnerWill/d4b6c776b509add763e17f9f113fd25b
}

while read -r -a PARTS; do
    parse-line "${PARTS[@]}"
done

echo "${!THEME_COLORS[@]}"
for i in {01..16}; do
    FG="${THEME_COLORS["color_${i}"]}"
    for j in {01..16}; do
        BG="${THEME_COLORS["color_${j}"]}"
        color-print "$FG" "$BG" " $i $j "
    done
    echo
done
