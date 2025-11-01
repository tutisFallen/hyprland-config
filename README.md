# Hypr Configuration Files

This repository contains my personal Hyprland configuration files. Hyprland is a dynamic tiling Wayland compositor.

## Shell Integration
I'm using [Exo shell](https://github.com/debuggyo/Exo) to complement these configurations.

## Prerequisites

Before installing the configuration files, you need to install the required packages. A script is provided to help you with this:

1. Clone this repository:
```bash
git clone https://github.com/tutisFallen/hyprland-config.git
cd hyprland-config
```

2. Install required packages (Arch Linux only):
```bash
chmod +x pacotes.sh
./pacotes.sh
```

The script will install all necessary packages from both official repositories and AUR.

## Configuration Installation

After installing the packages, you can install the configuration files:

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
