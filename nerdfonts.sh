#!/bin/bash

# System and local font directories
FONT_DIR="/usr/share/fonts/nerdfonts"
LOCAL_FONT_DIR="$HOME/.local/share/fonts"
sudo mkdir -p "$FONT_DIR"

# Array of font names
fonts=(
    "CascadiaCode"
    "FiraCode"
    "Hack"
    "Inconsolata"
    "JetBrainsMono"
    "Meslo"
    "Mononoki"
    "RobotoMono"
    "SourceCodePro"
    "UbuntuMono"
)

# Function to delete existing font installations (system and local)
delete_existing_font() {
    font_name=$1
    if [ -d "$FONT_DIR/$font_name" ]; then
        echo "Deleting system-wide installation of $font_name."
        sudo rm -rf "$FONT_DIR/$font_name"
    fi
    if [ -d "$LOCAL_FONT_DIR/$font_name" ]; then
        echo "Deleting local installation of $font_name."
        rm -rf "$LOCAL_FONT_DIR/$font_name"
    fi
    return 0  # Always proceed to install
}

LATEST_RELEASE=$(curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

# Loop through each font, delete existing, and install latest
for font in "${fonts[@]}"
do
    delete_existing_font "$font"

    echo "Downloading font: $font"
    wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/$LATEST_RELEASE/$font.tar.xz" -P /tmp

    if [ $? -ne 0 ]; then
        echo "Failed to download font: $font"
        continue
    fi

    # Create a subdirectory for the font
    sudo mkdir -p "$FONT_DIR/$font"

    echo "Extracting font to system directory: $font"
    sudo tar -xf "/tmp/$font.tar.xz" -C "$FONT_DIR/$font"

    if [ $? -ne 0 ]; then
        echo "Failed to extract font: $font"
        continue
    fi

    # Set correct permissions for the font files
    sudo chown -R root:root "$FONT_DIR/$font"
    sudo chmod -R 755 "$FONT_DIR/$font"

    rm "/tmp/$font.tar.xz"
done

# Update font cache
fc-cache -fv  # Update user font cache
sudo fc-cache -fv  # Update system font cache

echo "Fonts installation completed."
