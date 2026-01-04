#!/usr/bin/env bash

# Build menu items efficiently
menu_items=""
count=0

for i in {0..10}; do
  item=$(copyq read "$i" 2>/dev/null)
  if [ -n "$item" ]; then
    # Truncate to 100 chars and replace newlines with spaces
    display=$(echo "$item" | head -c 100 | tr '\n' ' ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    menu_items+="$i: $display"$'\n'
    ((count++))
  else
    break
  fi
done

# Check if we have any clips
if [ $count -eq 0 ]; then
  notify-send "Clipboard" "No clipboard history"
  exit 0
fi

# Show wofi menu and get selection (suppress GTK warnings)
choice=$(echo -n "$menu_items" | wofi --dmenu --insensitive --prompt "Clipboard" --width 800 --height 400 --cache-file=/dev/null 2>/dev/null)

if [ -n "$choice" ]; then
  # Extract index from choice
  index=$(echo "$choice" | cut -d: -f1 | xargs)
  # Select the item in copyq (copies to clipboard)
  copyq select "$index"
fi