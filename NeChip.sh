#!/bin/bash

# Script to install Node.js 20, pnpm, and pm2 on Ubuntu
# Author: PawSuki
# Date: January 2025
# License: MIT

# Clear the terminal
clear

# Function to display the NeChip LOGO
display_logo() {
    echo -e "\033[1;32m"  # Bright Green
    echo "  _   _           _     _         "
    echo " | \ | |         | |   (_)        "
    echo " |  \| | ___  ___| |__  _ _ __    "
    echo " | . \` |/ _ \/ __| '_ \| | '_ \   "
    echo " | |\  |  __/ (__| | | | | |_) |  "
    echo " |_| \_|\___|\___|_| |_|_| .__/   "
    echo "                        | |       "
    echo "                        |_|       "
    echo "  Node.js 20 + pnpm + pm2 Installer"
    echo -e "\033[0m"  # Reset color
    echo ""
}

# Function to update the progress bar
update_progress_bar() {
    local progress=$1
    local width=50
    local filled=$((progress * width / 100))
    local empty=$((width - filled))

    echo -ne "\rProgress: ["
    for ((i = 0; i < filled; i++)); do
        echo -ne "#"
    done
    for ((i = 0; i < empty; i++)); do
        echo -ne "-"
    done
    echo -ne "] ${progress}%"
}

# Function to perform an installation step
install_step() {
    local step_name=$1
    local step_command=$2
    local progress_increment=$3

    echo -ne "\033[1;36m\rStarting: $step_name... \033[0m"
    eval "$step_command" >>install_log.txt 2>&1
    current_progress=$((current_progress + progress_increment))
    update_progress_bar $current_progress
}

# Display logo
display_logo

# Initialize progress
current_progress=0
update_progress_bar $current_progress

# Create the log file
echo "Installation Log - $(date)" >install_log.txt

# Perform installation steps
install_step "Updating system packages" "sudo apt update -y && sudo apt upgrade -y" 20
install_step "Installing prerequisites" "sudo apt install -y curl wget build-essential" 15
install_step "Installing Node.js 20" "curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt install -y nodejs" 25
install_step "Installing pnpm" "corepack enable && corepack prepare pnpm@latest --activate" 20
install_step "Installing pm2 globally" "sudo npm install -g pm2" 15
install_step "Cleaning up unused packages" "sudo apt autoremove -y" 5

# Ensure progress is complete
current_progress=100
update_progress_bar $current_progress

# Display completion message
echo -e "\n\n\033[1;32mInstallation complete!\033[0m"
echo "Node.js, pnpm, and pm2 are successfully installed on your Ubuntu system."
echo "Logs are saved in 'install_log.txt'."

# Display final instructions
echo -e "\033[1;36m
To start using pm2, you can create an ecosystem file:
1. Run 'pm2 init' to generate a default ecosystem.config.js file.
2. Use 'pm2 start ecosystem.config.js' to run your applications.

For more information, visit:
- Node.js: https://nodejs.org/
- pnpm: https://pnpm.io/
- pm2: https://pm2.keymetrics.io/
\033[0m"
