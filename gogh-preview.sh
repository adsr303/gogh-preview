#!/usr/bin/env bash

#curl -s -L https://github.com/Gogh-Co/Gogh/raw/refs/heads/master/themes/Campbell.yml

# Working with stdin for now

parse-line() {
    local LINE="$1"
    case "$LINE" in
        color_[01][0-9]:* | background:* | foreground:* | cursor:* )
            local PARTS
            read -r -a PARTS <<< "$LINE"
            declare -gu "THEME_${LINE%%:*}"="${PARTS[1]:3:6}"
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
}
