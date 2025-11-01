# 🚀 Hyprland Configuration

A modern, modular Hyprland configuration designed for productivity and aesthetics. This setup provides a clean, efficient workspace with carefully crafted keybindings and visual settings.

![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=for-the-badge&logo=wayland&logoColor=black)
![Maintained](https://img.shields.io/badge/Maintained-Yes-green?style=for-the-badge)

## ✨ Features

- **Modular Configuration** - Organized into logical, easy-to-edit files
- **Exo Shell Powered** - Uses [Exo shell](https://github.com/debuggyo/Exo) instead of traditional bars for a unique, modern experience
- **Automatic Backup** - Installation script preserves your existing configs
- **Pre-configured Visuals** - Beautiful defaults for animations, borders, and transparency
- **Comprehensive Keybindings** - Intuitive keyboard shortcuts for efficient workflow
- **Multi-monitor Support** - Ready-to-configure monitor layouts
- **Window Rules** - Smart window management and application-specific behaviors

## 📋 Prerequisites

Before installing, ensure you have:

- **Arch Linux** (or Arch-based distribution)
- [Exo Shell](https://github.com/debuggyo/Exo) installed and configured
- Basic knowledge of Wayland compositors
- Terminal access
- Active internet connection for package installation

> **Note**: This configuration is optimized for Arch Linux. While it may work on other distributions, the installation scripts are designed for Arch-based systems.

## 🔧 Installation

### Method 1: Quick Install (Config Only)

This method installs only the Hyprland configuration files. You'll need to install the required packages separately.

```bash
# Clone the repository
git clone https://github.com/tutisFallen/hyprland-config.git
cd hyprland-config

# Make the installer executable
chmod +x install.sh

# Run the installation
./install.sh
```

**What the installer does:**

1. ✓ Creates `~/.config` directory if needed
2. ✓ Backs up existing Hypr configuration to `~/.config/hypr.backup.TIMESTAMP`
3. ✓ Copies all configuration files to `~/.config/hypr/`
4. ✓ Preserves your previous setup in case you need to revert

---

### Method 2: Full System Setup (Config + Packages)

This method installs both the configuration files AND all required packages automatically.

```bash
# Clone the repository
git clone https://github.com/tutisFallen/hyprland-config.git
cd hyprland-config

# Make both scripts executable
chmod +x install.sh instalar-pacotes.sh

# Install packages first
./instalar-pacotes.sh

# Then install configuration
./install.sh
```

**What the package installer does:**

- ✓ Updates your system
- ✓ Installs/verifies yay (AUR helper)
- ✓ Installs all official repository packages
- ✓ Installs all AUR packages
- ✓ Handles errors interactively with retry/skip options
- ✓ Provides a summary of any failed installations

**Interactive Error Handling:**

If a package fails to install, you'll see:

```
[AVISO] Falha ao instalar: package-name

O que deseja fazer?
  1) Tentar novamente
  2) Pular este pacote
  3) Pular todos os erros restantes
  4) Cancelar instalação

Escolha uma opção [1-4]:
```

Choose the option that best suits your needs. At the end, you'll get a summary of any packages that failed.

---

### Method 3: Manual Installation

If you prefer manual installation:

```bash
# Backup existing config (if any)
mv ~/.config/hypr ~/.config/hypr.backup

# Copy files
cp -r hypr ~/.config/
```

For manual package installation, refer to the [📦 Package List](#-package-list) section below.

## 📁 Configuration Structure

```
~/.config/hypr/
├── autostart.conf      # Autostart applications
├── hyprland.conf       # Main config (imports all others)
├── hyprlock.conf       # Lock screen appearance
├── hyprpaper.conf      # Wallpaper settings
├── input.conf          # Keyboard, mouse, touchpad
├── keybinds.conf       # Keyboard shortcuts
├── monitors.conf       # Display configuration
├── rules.conf          # Window rules and behaviors
├── variables.conf      # Custom variables
├── visuals.conf        # Animations, borders, effects
└── workspaces.conf     # Workspace setup
```

### Configuration Files Explained

| File | Purpose |
|------|---------|
| `autostart.conf` | Programs launched at startup (bars, notifications, etc.) |
| `hyprland.conf` | Main entry point that sources all other configs |
| `hyprlock.conf` | Customization for the lock screen |
| `hyprpaper.conf` | Wallpaper daemon configuration |
| `input.conf` | Input device settings (keyboard layout, mouse acceleration, etc.) |
| `keybinds.conf` | All keyboard shortcuts and hotkeys |
| `monitors.conf` | Monitor arrangement, resolution, and scaling |
| `rules.conf` | Window-specific behaviors (floating, workspace assignment, etc.) |
| `variables.conf` | Custom variables for reusable values |
| `visuals.conf` | Appearance settings (gaps, borders, animations, blur, etc.) |
| `workspaces.conf` | Workspace configuration and layout rules |

## ⚙️ Customization

### Monitors

Edit `monitors.conf` to match your setup:

```conf
monitor=DP-1,1920x1080@144,0x0,1
monitor=HDMI-A-1,1920x1080@60,1920x0,1
```

### Keybindings

Modify `keybinds.conf` to change shortcuts. Example format:

```conf
bind = SUPER, Return, exec, kitty
bind = SUPER, Q, killactive
```

### Appearance

Tweak `visuals.conf` for animations, borders, and effects to match your style.

### Autostart Programs

Add your preferred applications to `autostart.conf`:

```conf
exec-once = exo-shell
exec-once = dunst
```

---

## 📦 Package List

This configuration uses the following packages. They can be installed automatically using `instalar-pacotes.sh` or manually.

### Official Repositories

<details>
<summary>Click to expand full package list</summary>

**System Base:**
- base, base-devel
- linux, linux-firmware
- intel-ucode
- efibootmgr

**Chaotic-AUR:**
- chaotic-keyring
- chaotic-mirrorlist

**Hyprland & Wayland:**
- hyprland
- hyprlock
- hyprpaper
- hyprshot
- swww
- waybar
- rofi

**Network & Bluetooth:**
- networkmanager
- network-manager-applet
- bluez
- bluez-utils

**Audio (Pipewire):**
- pipewire
- pipewire-alsa
- pipewire-jack
- pipewire-pulse
- wireplumber
- libpulse
- gst-plugin-pipewire

**Terminal & Utilities:**
- kitty
- git
- nano
- btop
- fastfetch
- cava
- speedtest-cli

**Display Manager:**
- sddm

**Interface & Themes:**
- adw-gtk-theme
- papirus-icon-theme
- gnome-bluetooth-3.0
- nwg-displays
- thunar

**Fonts:**
- noto-fonts
- noto-fonts-cjk
- noto-fonts-emoji
- ttf-dejavu
- ttf-jetbrains-mono-nerd
- ttf-liberation
- woff2-font-awesome

**Development & Apps:**
- visual-studio-code-bin
- dart-sass

**System:**
- flatpak
- zram-generator
- yay

</details>

### AUR Packages

- adwaita-dark
- matugen-bin
- python-ignis-git
- ignis-gvc
- linuxtoys-bin
- ttf-material-symbols-variable-git

### Installing Packages Manually

If you prefer to install packages manually instead of using the automated script:

```bash
# Official packages
sudo pacman -S hyprland hyprlock hyprpaper waybar rofi kitty ...

# AUR packages
yay -S adwaita-dark matugen-bin python-ignis-git ...
```

Or use the generated package lists:

```bash
# If you have the package lists
sudo pacman -S --needed - < pacotes-oficiais.txt
yay -S --needed - < pacotes-aur.txt
```

## 🎨 Recommended Companion Tools

This config is designed to work with **Exo Shell** as the main shell/bar. Additional tools that complement this setup:

- **Shell/Bar**: [Exo Shell](https://github.com/debuggyo/Exo) (required)
- **Launcher**: Rofi (Wayland fork), Wofi
- **Notifications**: Dunst, Mako
- **Terminal**: Kitty, Alacritty, Foot
- **File Manager**: Thunar, Nautilus
- **Screenshot**: Grimblast, Grim + Slurp

## 🔄 Updating

To update your configuration:

```bash
cd hyprland-config
git pull
./install.sh
```

Your previous configuration will be backed up automatically.

To update packages:

```bash
# Update system packages
sudo pacman -Syu

# Update AUR packages
yay -Syu

# Or re-run the package installer
./instalar-pacotes.sh
```

## 🐛 Troubleshooting

### Hyprland won't start
- Check logs: `~/.local/share/hyprland/hyprland.log`
- Verify syntax in config files
- Ensure all required packages are installed: `./instalar-pacotes.sh`

### Keybindings not working
- Ensure no conflicting bindings
- Check if the command/application exists
- Verify the application is in your PATH

### Display issues
- Review `monitors.conf` settings
- Run `hyprctl monitors` to see detected displays
- Check if Wayland is properly configured

### Package installation fails
- The installation script will prompt you with options
- You can retry, skip, or install manually
- Check the summary at the end for failed packages
- Try installing failed packages manually:
  ```bash
  sudo pacman -S package-name  # For official repos
  yay -S package-name          # For AUR
  ```

### Exo Shell not working
- Verify Exo Shell is installed: `which exo-shell`
- Check if it's in autostart.conf
- See [Exo Shell documentation](https://github.com/debuggyo/Exo) for specific issues

### Missing dependencies
Run the package installer to ensure all dependencies are met:
```bash
./instalar-pacotes.sh
```

## 📝 Contributing

Suggestions and improvements are welcome! Feel free to:

- 🐛 Open an issue for bugs or feature requests
- 🔧 Submit a pull request with enhancements
- 💡 Share your modifications and customizations
- ⭐ Star the repo if you find it useful!

## 📄 License

This configuration is provided as-is for personal use. Feel free to modify and distribute as needed.

## 🙏 Acknowledgments

- [Hyprland](https://github.com/hyprwm/Hyprland) - The amazing Wayland compositor
- [Exo Shell](https://github.com/debuggyo/Exo) - Shell integration
- The Hyprland community for inspiration and support
- All package maintainers in Arch repos and AUR

## 📊 Repository Structure

```
hyprland-config/
├── hypr/                    # Configuration files
│   ├── autostart.conf
│   ├── hyprland.conf
│   ├── hyprlock.conf
│   ├── hyprpaper.conf
│   ├── input.conf
│   ├── keybinds.conf
│   ├── monitors.conf
│   ├── rules.conf
│   ├── variables.conf
│   ├── visuals.conf
│   └── workspaces.conf
├── install.sh               # Config installation script
├── instalar-pacotes.sh      # Package installation script
└── README.md
```

## 💬 Support

If you encounter issues:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Review the [Hyprland Wiki](https://wiki.hyprland.org/)
3. Open an issue on this repository
4. Join the Hyprland community for help

---

**Made with ❤️ by [tutisFallen](https://github.com/tutisFallen)**

*If you find this config useful, consider giving it a ⭐!*

---

## 🔖 Quick Links

- [Hyprland Official Site](https://hyprland.org/)
- [Hyprland GitHub](https://github.com/hyprwm/Hyprland)
- [Exo Shell](https://github.com/debuggyo/Exo)
- [Arch Wiki - Hyprland](https://wiki.archlinux.org/title/Hyprland)
