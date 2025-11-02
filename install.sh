#!/bin/bash

# Script de Instalação - Hyprland Config
# https://github.com/tutisFallen/hypr

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
print_info() { echo -e "${CYAN}ℹ${NC} $1"; }
print_header() { echo -e "\n${MAGENTA}═══════════════════════════════════════${NC}\n${BLUE}$1${NC}\n${MAGENTA}═══════════════════════════════════════${NC}\n"; }

# Arrays de pacotes
PACOTES_OFICIAIS=(
    "base" "base-devel" "bluez" "bluez-utils" "btop" "cava"
    "chaotic-keyring" "chaotic-mirrorlist" "cli11" "cliphist"
    "cmake" "cmatrix" "dart-sass" "dolphin" "efibootmgr"
    "evtest" "fastfetch" "ffmpegthumbnailer" "flatpak" "fzf"
    "gamemode" "gamescope" "git" "gnome-bluetooth"
    "gnome-bluetooth-3.0" "gnome-control-center" "gst-plugin-pipewire"
    "gum" "hyprland" "hyprlock" "hyprpaper" "hyprpicker"
    "hyprpolkitagent" "hyprshot" "hyprsunset" "intel-ucode"
    "inxi" "jemalloc" "kitty" "lib32-gamemode" "libpulse"
    "libva-utils" "libvdpau-va-gl" "linux" "linux-firmware"
    "mangohud" "mate-polkit" "nano" "noto-fonts" "noto-fonts-cjk"
    "noto-fonts-emoji" "nwg-displays" "papirus-icon-theme" "paru"
    "pipewire" "pipewire-alsa" "pipewire-jack" "pipewire-pulse"
    "polychromatic" "power-profiles-daemon" "python-j2cli"
    "python-numpy" "python-pip" "qt6-virtualkeyboard" "rofi"
    "sddm" "speedtest-cli" "steam" "swww" "thunar" "ttf-dejavu"
    "ttf-jetbrains-mono-nerd" "ttf-liberation" "ttf-nerd-fonts-symbols-mono"
    "tumbler" "vdpauinfo" "visual-studio-code-bin" "vulkan-radeon"
    "vulkan-tools" "waybar" "wireplumber" "xdg-desktop-portal-wlr"
    "yay" "zip" "zram-generator"
    # Dependências para Web Scraper
    "python-beautifulsoup4" "python-requests" "chromium" "chromedriver"
)

PACOTES_AUR=(
    "adwaita-dark" "dgop-bin" "dms-shell-git" "gbm"
    "google-breakpad" "gtk2" "ignis-gvc" "libopenrazer"
    "linuxtoys-bin" "matugen-bin" "mono-basic" "openrazer-meta-git"
    "python-ignis-git" "quickshell" "razercommander" "razergenie"
    "rustdesk" "vicinae-bin" "yt-x-git" "gpu-screen-recorder-git"
    "python-materialyoucolor-git" "ttf-material-icons-git"
    "ttf-material-symbols-variable-git" "woff2-font-awesome"
    "woff2-material-symbols-variable-git"
    # Dependência para Web Scraper
    "python-selenium"
)

# Contadores
SUCCESS_COUNT=0
FAILED_COUNT=0
SKIPPED_COUNT=0
FAILED_PACKAGES=()

# Verificar se está rodando como root
if [[ $EUID -eq 0 ]]; then
   print_error "Não rode este script como root!"
   exit 1
fi

# Verificar se yay está instalado
check_yay() {
    if ! command -v yay &> /dev/null; then
        print_warning "yay não está instalado. Instalando..."
        sudo pacman -S --needed git base-devel
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay
        if command -v yay &> /dev/null; then
            print_success "yay instalado com sucesso!"
        else
            print_error "Falha ao instalar yay. Por favor, instale manualmente."
            exit 1
        fi
    fi
}

# Função para perguntar se pula o pacote
ask_skip() {
    local package=$1
    echo -e "\n${YELLOW}Pacote '${package}' falhou.${NC}"
    read -p "Deseja pular este pacote e continuar? (s/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Função para instalar pacotes oficiais
install_official() {
    print_header "📦 Instalando Pacotes Oficiais (pacman)"
    
    for package in "${PACOTES_OFICIAIS[@]}"; do
        if pacman -Qi "$package" &> /dev/null; then
            print_info "$package já está instalado"
            ((SUCCESS_COUNT++))
        else
            echo -e "\n${CYAN}Instalando:${NC} $package"
            if sudo pacman -S --needed --noconfirm "$package" 2>&1 | grep -q "error: target not found"; then
                print_error "Pacote '$package' não encontrado"
                if ask_skip "$package"; then
                    print_warning "Pulando $package"
                    FAILED_PACKAGES+=("$package (oficial)")
                    ((SKIPPED_COUNT++))
                else
                    print_error "Instalação cancelada pelo usuário"
                    exit 1
                fi
            else
                if pacman -Qi "$package" &> /dev/null; then
                    print_success "$package instalado"
                    ((SUCCESS_COUNT++))
                else
                    print_error "Falha ao instalar $package"
                    if ask_skip "$package"; then
                        FAILED_PACKAGES+=("$package (oficial)")
                        ((SKIPPED_COUNT++))
                    else
                        exit 1
                    fi
                fi
            fi
        fi
    done
}

# Função para instalar pacotes do AUR
install_aur() {
    print_header "🔧 Instalando Pacotes do AUR (yay)"
    
    for package in "${PACOTES_AUR[@]}"; do
        if yay -Qi "$package" &> /dev/null; then
            print_info "$package já está instalado"
            ((SUCCESS_COUNT++))
        else
            echo -e "\n${CYAN}Instalando:${NC} $package"
            if yay -S --needed --noconfirm "$package" 2>&1 | grep -q "error: target not found\|error: package"; then
                print_error "Pacote '$package' não encontrado no AUR"
                if ask_skip "$package"; then
                    print_warning "Pulando $package"
                    FAILED_PACKAGES+=("$package (AUR)")
                    ((SKIPPED_COUNT++))
                else
                    print_error "Instalação cancelada pelo usuário"
                    exit 1
                fi
            else
                if yay -Qi "$package" &> /dev/null; then
                    print_success "$package instalado"
                    ((SUCCESS_COUNT++))
                else
                    print_error "Falha ao instalar $package"
                    if ask_skip "$package"; then
                        FAILED_PACKAGES+=("$package (AUR)")
                        ((SKIPPED_COUNT++))
                    else
                        exit 1
                    fi
                fi
            fi
        fi
    done
}

# Função para mostrar resumo
show_summary() {
    print_header "📊 Resumo da Instalação"
    
    echo -e "${GREEN}✓ Instalados/Já instalados:${NC} $SUCCESS_COUNT"
    echo -e "${YELLOW}⚠ Pulados:${NC} $SKIPPED_COUNT"
    
    if [ ${#FAILED_PACKAGES[@]} -gt 0 ]; then
        echo -e "\n${RED}Pacotes que falharam/foram pulados:${NC}"
        for pkg in "${FAILED_PACKAGES[@]}"; do
            echo -e "  ${RED}•${NC} $pkg"
        done
    fi
    
    echo -e "\n${CYAN}═══════════════════════════════════════${NC}"
}

# Função para clonar repositório e copiar configs
setup_configs() {
    print_header "📥 Configurando Hyprland"
    
    local TEMP_DIR="/tmp/hypr-config"
    local CONFIG_DIR="$HOME/.config/hypr"
    
    # Remover diretório temporário se existir
    if [ -d "$TEMP_DIR" ]; then
        print_info "Removendo diretório temporário antigo..."
        rm -rf "$TEMP_DIR"
    fi
    
    # Clonar repositório
    print_info "Clonando repositório..."
    if git clone https://github.com/tutisFallen/hypr.git "$TEMP_DIR"; then
        print_success "Repositório clonado com sucesso!"
    else
        print_error "Falha ao clonar repositório"
        exit 1
    fi
    
    # Fazer backup da configuração existente
    if [ -d "$CONFIG_DIR" ]; then
        local BACKUP_DIR="$HOME/.config/hypr.backup.$(date +%Y%m%d_%H%M%S)"
        print_warning "Configuração existente encontrada!"
        print_info "Criando backup em: $BACKUP_DIR"
        mv "$CONFIG_DIR" "$BACKUP_DIR"
        print_success "Backup criado!"
    fi
    
    # Criar diretório de config
    mkdir -p "$HOME/.config"
    
    # Copiar configurações
    print_info "Copiando configurações para $CONFIG_DIR..."
    cp -r "$TEMP_DIR" "$CONFIG_DIR"
    print_success "Configurações copiadas!"
    
    # Limpar diretório temporário
    rm -rf "$TEMP_DIR"
    
    # Dar permissões corretas
    chmod -R 755 "$CONFIG_DIR"
    if [ -d "$CONFIG_DIR/scripts" ]; then
        chmod +x "$CONFIG_DIR/scripts/"* 2>/dev/null
        print_success "Permissões configuradas!"
    fi
}

# Função para ativar serviços
enable_services() {
    print_header "🔧 Ativando Serviços"
    
    # Bluetooth
    if systemctl is-enabled bluetooth &> /dev/null; then
        print_info "Bluetooth já está ativado"
    else
        print_info "Ativando Bluetooth..."
        sudo systemctl enable --now bluetooth
        print_success "Bluetooth ativado!"
    fi
    
    # SDDM
    if systemctl is-enabled sddm &> /dev/null; then
        print_info "SDDM já está ativado"
    else
        print_info "Ativando SDDM..."
        sudo systemctl enable sddm
        print_success "SDDM ativado!"
    fi
}

# Função para instalar tema SDDM
install_sddm_theme() {
    print_header "🎨 Instalando Tema SDDM Astronaut"
    
    echo -e "${CYAN}Este tema dá um visual espacial incrível para sua tela de login!${NC}\n"
    
    read -p "Deseja instalar o tema SDDM Astronaut? (S/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        print_info "Instalando tema SDDM Astronaut..."
        if sh -c "$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)"; then
            print_success "Tema SDDM Astronaut instalado com sucesso!"
        else
            print_warning "Falha ao instalar tema SDDM (não crítico)"
            print_info "Você pode instalar manualmente depois com:"
            echo -e "  ${YELLOW}sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh)\"${NC}"
        fi
    else
        print_info "Pulando instalação do tema SDDM"
    fi
}

# Função para baixar wallpapers
download_wallpapers() {
    print_header "🖼️ Banco de Wallpapers"
    
    echo -e "${CYAN}Deseja baixar o banco de wallpapers JaKooLit?${NC}"
    echo -e "${YELLOW}Contém:${NC} 454 wallpapers incríveis"
    echo -e "${RED}⚠ ATENÇÃO: Tamanho aproximado: 1.10 GB${NC}\n"
    
    read -p "Baixar wallpapers? (s/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        local TEMP_WALLPAPER="/tmp/Wallpaper-Bank"
        local PICTURES_DIR="$HOME/Pictures"
        local WALLPAPER_DEST="$PICTURES_DIR/Wallpapers"
        
        # Remover diretório temporário se existir
        if [ -d "$TEMP_WALLPAPER" ]; then
            rm -rf "$TEMP_WALLPAPER"
        fi
        
        print_info "Baixando wallpapers (isso pode demorar um pouco)..."
        if git clone https://github.com/JaKooLit/Wallpaper-Bank.git "$TEMP_WALLPAPER"; then
            print_success "Wallpapers baixados!"
            
            # Criar pasta Pictures se não existir
            if [ ! -d "$PICTURES_DIR" ]; then
                print_info "Criando pasta Pictures..."
                mkdir -p "$PICTURES_DIR"
            fi
            
            # Remover destino se existir
            if [ -d "$WALLPAPER_DEST" ]; then
                print_warning "Removendo wallpapers antigos..."
                rm -rf "$WALLPAPER_DEST"
            fi
            
            # Mover apenas a pasta wallpapers de dentro do repositório
            print_info "Movendo wallpapers para $WALLPAPER_DEST..."
            if [ -d "$TEMP_WALLPAPER/wallpapers" ]; then
                mv "$TEMP_WALLPAPER/wallpapers" "$WALLPAPER_DEST"
                print_success "Wallpapers instalados em: $WALLPAPER_DEST"
                print_info "Total: 454 wallpapers disponíveis!"
            else
                print_error "Pasta wallpapers não encontrada no repositório"
            fi
            
            # Limpar diretório temporário
            rm -rf "$TEMP_WALLPAPER"
        else
            print_error "Falha ao baixar wallpapers"
            print_info "Você pode baixar manualmente depois:"
            echo -e "  ${YELLOW}git clone https://github.com/JaKooLit/Wallpaper-Bank.git /tmp/Wallpaper-Bank${NC}"
            echo -e "  ${YELLOW}mv /tmp/Wallpaper-Bank/wallpapers ~/Pictures/Wallpapers${NC}"
        fi
    else
        print_info "Pulando download de wallpapers"
    fi
}

# Função para reiniciar sistema
ask_reboot() {
    print_header "🔄 Reinicialização Necessária"
    
    echo -e "${YELLOW}Para aplicar todas as configurações, é recomendado reiniciar o sistema.${NC}"
    echo -e "${CYAN}Após reiniciar, selecione Hyprland na tela de login.${NC}\n"
    
    read -p "Deseja reiniciar agora? (s/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        print_info "Reiniciando em 5 segundos..."
        sleep 1
        print_warning "5..."
        sleep 1
        print_warning "4..."
        sleep 1
        print_warning "3..."
        sleep 1
        print_warning "2..."
        sleep 1
        print_warning "1..."
        sleep 1
        print_success "Reiniciando sistema!"
        sudo reboot
    else
        print_info "Reinicialização adiada."
        echo -e "\n${CYAN}Para reiniciar depois, execute:${NC} ${YELLOW}sudo reboot${NC}\n"
    fi
}

# Função principal
main() {
    clear
    echo -e "${MAGENTA}"
    cat << "EOF"
    ╦ ╦╦ ╦╔═╗╦═╗  ╦╔╗╔╔═╗╔╦╗╔═╗╦  ╦  
    ╠═╣╚╦╝╠═╝╠╦╝  ║║║║╚═╗ ║ ╠═╣║  ║  
    ╩ ╩ ╩ ╩  ╩╚═  ╩╝╚╝╚═╝ ╩ ╩ ╩╩═╝╩═╝
EOF
    echo -e "${NC}"
    print_info "Script de Instalação Automática"
    print_info "https://github.com/tutisFallen/hypr"
    
    echo -e "\n${YELLOW}Este script irá:${NC}"
    echo -e "  ${CYAN}1.${NC} Atualizar o sistema"
    echo -e "  ${CYAN}2.${NC} Instalar todos os pacotes necessários"
    echo -e "  ${CYAN}3.${NC} Clonar e configurar o Hyprland"
    echo -e "  ${CYAN}4.${NC} Ativar serviços necessários"
    echo -e "  ${CYAN}5.${NC} Instalar tema SDDM Astronaut (opcional)"
    echo -e "  ${CYAN}6.${NC} Baixar banco de wallpapers - 1.10 GB (opcional)"
    echo -e "  ${CYAN}7.${NC} Oferecer reinicialização do sistema"
    echo -e "\n${YELLOW}Você será perguntado se deseja pular pacotes que falharem.${NC}\n"
    
    read -p "Deseja continuar? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_warning "Instalação cancelada"
        exit 0
    fi
    
    # Atualizar sistema
    print_header "🔄 Atualizando Sistema"
    sudo pacman -Syu --noconfirm
    
    # Verificar e instalar yay
    check_yay
    
    # Instalar pacotes
    install_official
    install_aur
    
    # Mostrar resumo
    show_summary
    
    # Configurar Hyprland
    setup_configs
    
    # Ativar serviços
    enable_services
    
    # Instalar tema SDDM
    install_sddm_theme
    
    # Baixar wallpapers
    download_wallpapers
    
    # Mensagem final
    print_header "🎉 Instalação Concluída!"
    print_success "Todas as configurações foram aplicadas!"
    echo -e "\n${CYAN}Dicas finais:${NC}"
    echo -e "  ${CYAN}•${NC} Configure monitores com: ${YELLOW}nwg-displays${NC}"
    echo -e "  ${CYAN}•${NC} Suas configs antigas (se existiam) foram backupeadas"
    echo -e "  ${CYAN}•${NC} Wallpapers estão em: ${YELLOW}~/Pictures/Wallpapers${NC} (se instalados)"
    echo -e "  ${CYAN}•${NC} Após reiniciar, selecione ${YELLOW}Hyprland${NC} na tela de login"
    echo ""
    
    # Perguntar se quer reiniciar
    ask_reboot
}

# Executar script
main