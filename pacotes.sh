#!/bin/bash

# Script de instalação de pacotes - Arch Linux + AUR
# Criado automaticamente

set -e

echo "=================================="
echo "  Instalação de Pacotes - Arch"
echo "=================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Variáveis de controle
FALHAS=()
MODO_INTERATIVO=true

# Função para perguntar ao usuário
perguntar_acao() {
    local pacote=$1
    echo ""
    echo -e "${YELLOW}[AVISO]${NC} Falha ao instalar: ${RED}$pacote${NC}"
    echo ""
    echo "O que deseja fazer?"
    echo "  1) Tentar novamente"
    echo "  2) Pular este pacote"
    echo "  3) Pular todos os erros restantes"
    echo "  4) Cancelar instalação"
    echo ""
    read -p "Escolha uma opção [1-4]: " opcao
    
    case $opcao in
        1)
            return 0  # Tentar novamente
            ;;
        2)
            FALHAS+=("$pacote")
            return 1  # Pular
            ;;
        3)
            MODO_INTERATIVO=false
            FALHAS+=("$pacote")
            return 1  # Pular todos
            ;;
        4)
            echo -e "${RED}[ERRO]${NC} Instalação cancelada pelo usuário."
            exit 1
            ;;
        *)
            echo -e "${YELLOW}[AVISO]${NC} Opção inválida. Pulando pacote..."
            FALHAS+=("$pacote")
            return 1
            ;;
    esac
}

# Função para instalar pacote com retry
instalar_pacote_oficial() {
    local pacote=$1
    local tentativas=0
    
    while true; do
        tentativas=$((tentativas + 1))
        echo -e "${BLUE}[INFO]${NC} Instalando: $pacote (tentativa $tentativas)"
        
        if sudo pacman -S --needed --noconfirm "$pacote" 2>/dev/null; then
            echo -e "${GREEN}[OK]${NC} $pacote instalado com sucesso!"
            return 0
        else
            if [ "$MODO_INTERATIVO" = true ]; then
                if perguntar_acao "$pacote"; then
                    continue  # Tentar novamente
                else
                    return 1  # Pular
                fi
            else
                echo -e "${RED}[ERRO]${NC} Pulando $pacote..."
                FALHAS+=("$pacote")
                return 1
            fi
        fi
    done
}

# Função para instalar pacote do AUR com retry
instalar_pacote_aur() {
    local pacote=$1
    local tentativas=0
    
    while true; do
        tentativas=$((tentativas + 1))
        echo -e "${BLUE}[INFO]${NC} Instalando do AUR: $pacote (tentativa $tentativas)"
        
        if yay -S --needed --noconfirm "$pacote" 2>/dev/null; then
            echo -e "${GREEN}[OK]${NC} $pacote instalado com sucesso!"
            return 0
        else
            if [ "$MODO_INTERATIVO" = true ]; then
                if perguntar_acao "$pacote"; then
                    continue  # Tentar novamente
                else
                    return 1  # Pular
                fi
            else
                echo -e "${RED}[ERRO]${NC} Pulando $pacote..."
                FALHAS+=("$pacote")
                return 1
            fi
        fi
    done
}

# Função para verificar se yay está instalado
check_yay() {
    if ! command -v yay &> /dev/null; then
        echo -e "${RED}[ERRO]${NC} yay não está instalado!"
        echo "Instalando yay..."
        
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay
        
        echo -e "${GREEN}[OK]${NC} yay instalado com sucesso!"
    else
        echo -e "${GREEN}[OK]${NC} yay já está instalado"
    fi
}

# Atualizar sistema
echo -e "${BLUE}[INFO]${NC} Atualizando sistema..."
sudo pacman -Syu --noconfirm

# Verificar yay
check_yay

# Pacotes oficiais dos repositórios do Arch
echo ""
echo -e "${BLUE}[INFO]${NC} Instalando pacotes oficiais..."
PACOTES_OFICIAIS=(
    # Sistema base
    base
    base-devel
    linux
    linux-firmware
    intel-ucode
    efibootmgr
    
    # Repositórios Chaotic-AUR
    chaotic-keyring
    chaotic-mirrorlist
    
    # Hyprland e Wayland
    hyprland
    hyprlock
    hyprpaper
    hyprshot
    swww
    waybar
    rofi
    
    # Network e Bluetooth
    networkmanager
    network-manager-applet
    bluez
    bluez-utils
    
    # Audio (Pipewire)
    pipewire
    pipewire-alsa
    pipewire-jack
    pipewire-pulse
    wireplumber
    libpulse
    gst-plugin-pipewire
    
    # Terminal e Utilitários
    kitty
    git
    nano
    btop
    fastfetch
    cava
    speedtest-cli
    
    # Display Manager
    sddm
    
    # Interface e Temas
    adw-gtk-theme
    papirus-icon-theme
    gnome-bluetooth-3.0
    nwg-displays
    thunar
    
    # Fontes
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ttf-dejavu
    ttf-jetbrains-mono-nerd
    ttf-liberation
    woff2-font-awesome
    
    # Desenvolvimento e Apps
    visual-studio-code-bin
    dart-sass
    
    # Sistema
    flatpak
    zram-generator
    
    # Gerenciador de pacotes AUR
    yay
)

for pacote in "${PACOTES_OFICIAIS[@]}"; do
    instalar_pacote_oficial "$pacote"
done

# Pacotes do AUR
echo ""
echo -e "${BLUE}[INFO]${NC} Instalando pacotes do AUR..."
PACOTES_AUR=(
    # Temas e customização
    adwaita-dark
    matugen-bin
    
    # Python e Ignis
    python-ignis-git
    ignis-gvc
    
    # Utilitários
    linuxtoys-bin
    ttf-material-symbols-variable-git
    
    # Debug (opcional)
    # yay-debug
)

for pacote in "${PACOTES_AUR[@]}"; do
    instalar_pacote_aur "$pacote"
done

echo ""
echo -e "${GREEN}=================================="
echo -e "  Instalação concluída!"
echo -e "==================================${NC}"
echo ""

# Mostrar resumo
if [ ${#FALHAS[@]} -eq 0 ]; then
    echo -e "${GREEN}✓ Todos os pacotes foram instalados com sucesso!${NC}"
else
    echo -e "${YELLOW}⚠ Instalação concluída com avisos:${NC}"
    echo ""
    echo -e "${RED}Pacotes que falharam (${#FALHAS[@]}):${NC}"
    for pacote in "${FALHAS[@]}"; do
        echo -e "  ${RED}✗${NC} $pacote"
    done
    echo ""
    echo -e "${BLUE}[DICA]${NC} Você pode tentar instalar manualmente com:"
    echo -e "  ${YELLOW}sudo pacman -S <pacote>${NC} (oficial)"
    echo -e "  ${YELLOW}yay -S <pacote>${NC} (AUR)"
fi

echo ""
echo "Instalação finalizada!"