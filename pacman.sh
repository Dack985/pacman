#!/bin/bash

# Minimum terminal size required for pacman4console
MIN_WIDTH=80
MIN_HEIGHT=24

# Function to handle Ctrl+C
handle_interrupt() {
    echo -e "\nHahaha, Ctrl+C won't work! Maximize your terminal window to continue!"
    sleep 2  # Short delay to reinforce the message
    trap 'handle_interrupt' SIGINT  # Re-engage the trap for Ctrl+C
}

# Function to check terminal size
check_terminal_size() {
    while :; do
        width=$(tput cols)
        height=$(tput lines)

        if [ "$width" -ge $MIN_WIDTH ] && [ "$height" -ge $MIN_HEIGHT ]; then
            break  # Terminal size is sufficient, proceed with the game
        else
            echo -e "\nMaximize your terminal window! (Minimum size: ${MIN_WIDTH}x${MIN_HEIGHT})"
            sleep 2  # Short delay to prevent excessive checks
        fi
    done
}

# Trap Ctrl+C
trap 'handle_interrupt' SIGINT

# Check terminal size and wait until the user resizes it
check_terminal_size

# Start the game
cd /usr/games || { echo "Failed to change directory to /usr/games"; exit 1; }
echo "Starting Pacman..."
./pacman4console
