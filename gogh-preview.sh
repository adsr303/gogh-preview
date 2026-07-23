#!/usr/bin/env bash

set -eu

declare -A THEME_COLORS

while read -r property_c value rest; do
  property="${property_c%:*}"
  case "$property" in
    color_[01][0-9] | background | foreground | cursor)
      THEME_COLORS+=(["$property"]="${value:2:6}")
      ;;
    name)
      THEME_NAME="$value ${rest[*]}" # Making a lot of assumptions here
      THEME_NAME="${THEME_NAME#*\'}"
      THEME_NAME="${THEME_NAME%\'*}"
      ;;
  esac
done

declare -r THEME_COLORS THEME_NAME

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
  local fg_r="0x${1:0:2}"
  local fg_g="0x${1:2:2}"
  local fg_b="0x${1:4:2}"

  local bg_r="0x${2:0:2}"
  local bg_g="0x${2:2:2}"
  local bg_b="0x${2:4:2}"

  printf "\033[38;2;%d;%d;%d;48;2;%d;%d;%dm%s\033[0m" \
    "$fg_r" "$fg_g" "$fg_b" "$bg_r" "$bg_g" "$bg_b" "$3"
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
  printf -v property "color_%02d" $i
  fg_t="${THEME_COLORS[$property]}"
  color_name="${COLOR_NAMES[i]}"
  color-print "$fg_t" "$BG" " $color_name $fg_t "
  color-print "$BG" "$fg_t" " $color_name $fg_t "
  printf -v property "color_%02d" $((i + 8))
  fg_t="${THEME_COLORS[$property]}"
  color-print "$fg_t" "$BG" " $color_name $fg_t "
  echo
done

color-println "$FG" "$BG" "$BLANK"
color-print "${THEME_COLORS[foreground]}" "$BG" ' $ '
color-print "${THEME_COLORS[cursor]}" "$BG" $'\u2588'"${BLANK:0:44}"
echo
color-println "$FG" "$BG" "$BLANK"
