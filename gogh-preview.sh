#!/usr/bin/env bash

#curl -s -L https://github.com/Gogh-Co/Gogh/raw/refs/heads/master/themes/Campbell.yml

# Working with stdin for now

declare -A THEME_COLORS

while read -r PROPERTY_C VALUE COMMENT; do
    PROPERTY="${PROPERTY_C%:*}"
    case "$PROPERTY" in
        color_[01][0-9] | background | foreground | cursor)
            THEME_COLORS+=(["$PROPERTY"]="${VALUE:2:6}")
            ;;
    esac
done

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

BG="${THEME_COLORS[background]}"
for i in {01..16}; do
    FG="${THEME_COLORS["color_${i}"]}"
    color-print "$FG" "$BG" " $i $FG "
    echo
done
