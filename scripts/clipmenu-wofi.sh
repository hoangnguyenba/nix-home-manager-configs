#!/usr/bin/env bash

# Get clipboard history from copyq
declare -A clips
for i in {0..49}; do
  item=$(copyq read "$i" 2>/dev/null)
  if [ -n "$item" ]; then
    # Truncate and clean the item for display
    display=$(echo "$item" | head -c 100 | tr '\n' ' ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    clips["$i"]="$display"
  fi
done

# Check if we have any clips
if [ ${#clips[@]} -eq 0 ]; then
  notify-send "Clipboard" "No clipboard history"
  exit 0
fi

# Create menu items
menu_items=""
for i in "${!clips[@]}"; do
  menu_items+="$i: ${clips[$i]}\n"
done

# Show wofi menu and get selection
choice=$(echo -e "$menu_items" | wofi --dmenu --insensitive --prompt "Clipboard" --width 800 --height 400)

if [ -n "$choice" ]; then
  # Extract index from choice
  index=$(echo "$choice" | cut -d: -f1)
  # Select the item in copyq (copies to clipboard)
  copyq select "$index"
fi