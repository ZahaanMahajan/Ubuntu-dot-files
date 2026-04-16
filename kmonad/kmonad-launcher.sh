#!/bin/bash
# kmonad-launcher.sh
# Finds all keyboard input devices and launches a KMonad instance for each.

KMONAD="/home/zahaan/.local/bin/kmonad"
TEMPLATE="/home/zahaan/.config/kmonad/kmonad-template.kbd"
TMPDIR="/tmp/kmonad-configs"

# Clean up on exit
cleanup() {
    echo "Stopping all KMonad instances..."
    kill $(jobs -p) 2>/dev/null
    rm -rf "$TMPDIR"
    exit 0
}
trap cleanup SIGTERM SIGINT

mkdir -p "$TMPDIR"

# Find all keyboard event devices
# Looks for devices that have EV_KEY and support actual keyboard keys (KEY_A = 30)
found=0
for event in /dev/input/event*; do
    # Check if device supports keyboard keys (not just a power button)
    if udevadm info --query=property --name="$event" 2>/dev/null | grep -q "ID_INPUT_KEYBOARD=1"; then
        name=$(udevadm info --query=property --name="$event" 2>/dev/null | grep "ID_MODEL=" | cut -d= -f2)
        [ -z "$name" ] && name=$(basename "$event")

        echo "Found keyboard: $name ($event)"

        # Create a config from template with this device path
        config="$TMPDIR/kmonad-$(basename $event).kbd"
        sed "s|DEVICE_PATH|$event|g" "$TEMPLATE" > "$config"

        # Launch KMonad in background
        "$KMONAD" "$config" &
        echo "  -> Started KMonad (PID $!)"
        found=$((found + 1))
    fi
done

if [ "$found" -eq 0 ]; then
    echo "No keyboards found! Waiting 5s and retrying..."
    sleep 5
    exec "$0"
fi

echo "Running $found KMonad instance(s). Waiting..."
wait
