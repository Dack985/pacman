#!/bin/bash

# Update package list and install pacman4console
echo "Installing pacman4console..."
sudo apt update
sudo apt install pacman4console -y

# Create the script to start Pacman with terminal check and signal trapping
echo "Creating start_pacman.sh script..."
cat << 'EOF' | sudo tee /usr/local/bin/start_pacman.sh
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
EOF

# Make the script executable
sudo chmod +x /usr/local/bin/start_pacman.sh

# Add the script to .bashrc to run on SSH login
if ! grep -q "/usr/local/bin/start_pacman.sh" ~/.bashrc; then
    echo "Adding start_pacman.sh to .bashrc..."
    echo "/usr/local/bin/start_pacman.sh" >> ~/.bashrc
else
    echo "start_pacman.sh already present in .bashrc"
fi

# Inform the user
echo "Installation complete! Pacman will start on the next SSH login, and Ctrl+C won't help you escape!"
