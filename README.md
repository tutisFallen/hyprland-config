# Hypr Configuration Files

This repository contains my personal Hyprland configuration files. Hyprland is a dynamic tiling Wayland compositor.

## Shell Integration
I'm using [Exo shell](https://github.com/debuggyo/Exo) to complement these configurations.

## Installation

1. Clone this repository:
```bash
git clone https://github.com/tutisFallen/hyprland-config.git
cd hyprland-config
```

2. Run the installation script:
```bash
chmod +x install.sh
./install.sh
```

The script will:
- Create ~/.config directory if it doesn't exist
- Backup your existing Hypr configuration if it exists
- Copy the new configuration files to ~/.config/hypr/

## Structure

- `autostart.conf` - Programs to start with Hyprland
- `hyprland.conf` - Main configuration file
- `hyprlock.conf` - Lock screen configuration
- `hyprpaper.conf` - Wallpaper configuration
- `input.conf` - Input device settings
- `keybinds.conf` - Keyboard shortcuts
- `monitors.conf` - Monitor layout configuration
- `rules.conf` - Window rules
- `variables.conf` - Variable definitions
- `visuals.conf` - Visual settings
- `workspaces.conf` - Workspace configuration
