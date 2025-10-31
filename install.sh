#!/bin/bash

echo "Installing Hyprland configuration files..."

# Check if ~/.config exists, if not create it
if [ ! -d "$HOME/.config" ]; then
    echo "Creating ~/.config directory..."
    mkdir -p "$HOME/.config"
fi

# Check if hypr config already exists
if [ -d "$HOME/.config/hypr" ]; then
    echo "Backing up existing Hypr configuration..."
    mv "$HOME/.config/hypr" "$HOME/.config/hypr.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Copy hypr directory to ~/.config
echo "Copying new configuration files..."
cp -r hypr "$HOME/.config/"

echo "Done! Hyprland configuration has been installed."
echo "Your old configuration (if it existed) has been backed up with a timestamp."
echo "You may need to restart Hyprland for changes to take effect."