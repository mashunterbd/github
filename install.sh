#!/bin/bash

# Function to print text in blue color
print_blue() {
    echo "$(tput setaf 4)$1$(tput sgr0)"
}

# Install required packages
apt install wget git -y || { echo "Failed to install required packages"; exit 1; }

# Download github.sh script
wget -O github.sh https://raw.githubusercontent.com/mashunterbd/github/main/github.sh || { echo "Failed to download script"; exit 1; }

# Set execute permission
chmod +x github.sh || { echo "Failed to set execute permission"; exit 1; }

# Rename the file
mv github.sh github || { echo "Failed to rename file"; exit 1; }

# Move the file to bin
mv github /usr/local/bin/ || { echo "Failed to move file to bin"; exit 1; }

# Clean up
rm -rf install.sh || { echo "Failed to remove install.sh"; exit 1; }

# Success message in blue color
print_blue "Installation successful. You can now use 'github --help'."
