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
print_step() { echo -e "${BLUE}➜${NC} $1"; }

# Arrays de pacotes organizados por categoria
PACOTES_BASE=(
    "base" "base-devel" "linux" "linux-firmware" "efibootmgr" "intel-ucode"
)

PACOTES_ESSENCIAIS=(
    "git" "nano" "zip" "unzip" "sudo" "curl" "wget" "fzf" "gum"
)

PACOTES_HYPRLAND=(
    "hyprland" "hyprlock" "hyprpaper" "hyprpicker" "hyprpolkitagent" 
    "hyprshot" "hyprsunset" "waybar" "rofi" "kitty" "dolphin" "thunar"
)

PACOTES_AUDIO=(
    "pipewire" "pipewire-alsa" "pipewire-pulse" "pipewire-jack" 
    "wireplumber" "libpulse"
)

PACOTES_GPU=(
    "vulkan-radeon" "vulkan-tools" "libva-utils" "libvdpau-va-gl" "vdpauinfo"
)

PACOTES_UTILITARIOS=(
    "btop" "cava" "cmatrix" "fastfetch" "inxi" "speedtest-cli" "cliphist"
    "ffmpegthumbnailer" "tumbler" "gamemode" "gamescope" "lib32-gamemode"
    "mangohud" "polychromatic" "power-profiles-daemon"
)

PACOTES_FONTES=(
    "noto-fonts" "noto-fonts-cjk" "noto-fonts-emoji" "ttf-dejavu"
    "ttf-jetbrains-mono-nerd" "ttf-liberation" "ttf-nerd-fonts-symbols-mono"
)

PACOTES_SISTEMA=(
    "bluez" "bluez-utils" "gnome-bluetooth" "gnome-bluetooth-3.0"
    "gnome-control-center" "flatpak" "sddm" "xdg-desktop-portal-wlr"
    "mate-polkit" "zram-generator"
)

PACOTES_DESENVOLVIMENTO=(
    "visual-studio-code-bin" "dart-sass" "cmake" "cli11" "jemalloc"
    "python-pip" "python-numpy" "python-j2cli"
    "python-beautifulsoup4" "python-requests" "chromium" "chromedriver"
)

PACOTES_AUR_ESSENCIAIS=(
    "paru" "yay" "adwaita-dark" "matugen-bin" "quickshell" "rustdesk"
    "gpu-screen-recorder-git" "linuxtoys-bin" "vicinae-bin" "yt-x-git"
)

PACOTES_AUR_RAZER=(
    "openrazer-meta-git" "razergenie" "razercommander" "libopenrazer"
    "python-ignis-git" "dgop-bin" "ignis-gvc" "gbm" "google-breakpad" "gtk2"
)

PACOTES_AUR_THEMES=(
    "ttf-material-icons-git" "ttf-material-symbols-variable-git"
    "woff2-font-awesome" "woff2-material-symbols-variable-git"
    "python-materialyoucolor-git" "mono-basic" "dms-shell-git"
)

# Combinar todos os pacotes oficiais
PACOTES_OFICIAIS=(
    "${PACOTES_BASE[@]}" "${PACOTES_ESSENCIAIS[@]}" "${PACOTES_HYPRLAND[@]}"
    "${PACOTES_AUDIO[@]}" "${PACOTES_GPU[@]}" "${PACOTES_UTILITARIOS[@]}"
    "${PACOTES_FONTES[@]}" "${PACOTES_SISTEMA[@]}" "${PACOTES_DESENVOLVIMENTO[@]}"
)

# Combinar todos os pacotes AUR
PACOTES_AUR=(
    "${PACOTES_AUR_ESSENCIAIS[@]}" "${PACOTES_AUR_RAZER[@]}" "${PACOTES_AUR_THEMES[@]}"
)

# Variáveis globais
SUCCESS_COUNT=0
FAILED_COUNT=0
SKIPPED_COUNT=0
FAILED_PACKAGES=()
TEMP_DIR="/tmp/hyprland-installer"
LOG_FILE="$TEMP_DIR/installation.log"

# Criar diretório temporário e arquivo de log
mkdir -p "$TEMP_DIR"
exec > >(tee -a "$LOG_FILE") 2>&1

# ===== FUNÇÕES DE UTILIDADE =====

# Função para limpar em caso de interrupção
cleanup() {
    echo
    print_warning "Script interrompido pelo usuário"
    print_info "Log salvo em: $LOG_FILE"
    exit 1
}

trap cleanup SIGINT

# Função para verificar conexão com internet
check_internet() {
    print_step "Verificando conexão com a internet..."
    if ! curl -Is https://archlinux.org > /dev/null 2>&1; then
        print_error "Sem conexão com a internet!"
        exit 1
    fi
    print_success "Conexão OK"
}

# Função para verificar se é Arch Linux
check_arch() {
    if [[ ! -f /etc/arch-release ]]; then
        print_error "Este script só funciona no Arch Linux!"
        exit 1
    fi
}

# Função para verificar se está rodando como root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "Não rode este script como root!"
        exit 1
    fi
}

# Função para confirmar execução
confirm_execution() {
    echo -e "\n${YELLOW}Este script irá instalar:${NC}"
    echo -e "  ${CYAN}•${NC} ${#PACOTES_OFICIAIS[@]} pacotes oficiais"
    echo -e "  ${CYAN}•${NC} ${#PACOTES_AUR[@]} pacotes do AUR"
    echo -e "  ${CYAN}•${NC} Configuração completa do Hyprland"
    echo -e "  ${CYAN}•${NC} Tema SDDM Astronaut (opcional)"
    echo -e "  ${CYAN}•${NC} Wallpapers (1.1GB, opcional)"
    echo -e "\n${RED}⚠  ATENÇÃO: Isso modificará seu sistema!${NC}"
    
    read -p $'\n'"Continuar? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_warning "Instalação cancelada"
        exit 0
    fi
}

# ===== FUNÇÕES DE INSTALAÇÃO =====

# Função para instalar yay se necessário
install_yay() {
    if command -v yay &> /dev/null; then
        print_success "yay já está instalado"
        return 0
    fi

    print_step "Instalando yay..."
    if sudo pacman -S --needed --noconfirm git base-devel && \
       git clone https://aur.archlinux.org/yay.git /tmp/yay && \
       cd /tmp/yay && \
       makepkg -si --noconfirm; then
        cd -
        rm -rf /tmp/yay
        print_success "yay instalado com sucesso!"
        return 0
    else
        print_error "Falha ao instalar yay"
        return 1
    fi
}

# Função para verificar se pacote existe no repositório
package_exists() {
    local package=$1
    local repo=$2
    
    if [[ $repo == "official" ]]; then
        pacman -Si "$package" &> /dev/null
    else
        yay -Si "$package" &> /dev/null
    fi
}

# Função para verificar se pacote está instalado
is_package_installed() {
    local package=$1
    local repo=$2
    
    if [[ $repo == "official" ]]; then
        pacman -Qi "$package" &> /dev/null
    else
        yay -Qi "$package" &> /dev/null
    fi
}

# Função para instalar pacote individual
install_package() {
    local package=$1
    local repo=$2
    
    if is_package_installed "$package" "$repo"; then
        print_info "$package já está instalado"
        ((SUCCESS_COUNT++))
        return 0
    fi
    
    if ! package_exists "$package" "$repo"; then
        print_error "$package não encontrado no $repo"
        FAILED_PACKAGES+=("$package ($repo)")
        ((SKIPPED_COUNT++))
        return 1
    fi
    
    print_step "Instalando $package..."
    if [[ $repo == "official" ]]; then
        if sudo pacman -S --needed --noconfirm "$package"; then
            print_success "$package instalado"
            ((SUCCESS_COUNT++))
            return 0
        fi
    else
        if yay -S --needed --noconfirm "$package"; then
            print_success "$package instalado"
            ((SUCCESS_COUNT++))
            return 0
        fi
    fi
    
    print_error "Falha ao instalar $package"
    FAILED_PACKAGES+=("$package ($repo)")
    ((SKIPPED_COUNT++))
    return 1
}

# Função para instalar grupos de pacotes
install_package_group() {
    local group_name=$1
    local packages=("${!2}")
    local repo=$3
    
    print_header "📦 Instalando $group_name"
    
    for package in "${packages[@]}"; do
        install_package "$package" "$repo"
    done
}

# ===== FUNÇÕES DE CONFIGURAÇÃO =====

# Função para configurar Hyprland
setup_hyprland() {
    print_header "🎨 Configurando Hyprland"
    
    local CONFIG_DIR="$HOME/.config/hypr"
    local BACKUP_DIR="$HOME/.config/hypr.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Backup se existir
    if [[ -d "$CONFIG_DIR" ]]; then
        print_step "Fazendo backup da configuração existente..."
        mv "$CONFIG_DIR" "$BACKUP_DIR"
        print_success "Backup criado: $BACKUP_DIR"
    fi
    
    # Clonar repositório
    print_step "Clonando repositório de configuração..."
    if git clone https://github.com/tutisFallen/Hyprland-Config.git "$CONFIG_DIR"; then
        print_success "Configurações clonadas"
    else
        print_error "Falha ao clonar repositório"
        return 1
    fi
    
    # Configurar permissões
    if [[ -d "$CONFIG_DIR/scripts" ]]; then
        chmod +x "$CONFIG_DIR/scripts/"*
        print_success "Permissões configuradas"
    fi
    
    return 0
}

# Função para ativar serviços
enable_services() {
    print_header "🔧 Ativando Serviços"
    
    local services=("bluetooth" "sddm")
    
    for service in "${services[@]}"; do
        print_step "Ativando $service..."
        if sudo systemctl enable "$service" 2>/dev/null; then
            print_success "$service ativado"
        else
            print_warning "Não foi possível ativar $service"
        fi
    done
}

# Função para instalar tema SDDM
install_sddm_theme() {
    print_header "🌙 Instalando Tema SDDM Astronaut"
    
    read -p "Instalar tema SDDM Astronaut? (S/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        print_info "Tema SDDM pulado"
        return 0
    fi
    
    print_step "Instalando tema SDDM Astronaut..."
    if curl -fsSL https://raw.githubusercontent.com/keyitdev/sddm-astronaut-theme/master/setup.sh | sh; then
        print_success "Tema SDDM instalado"
    else
        print_warning "Falha ao instalar tema SDDM"
    fi
}

# Função para baixar wallpapers
download_wallpapers() {
    print_header "🖼️  Baixando Wallpapers"
    
    echo -e "${YELLOW}Tamanho: ~1.1GB - Pode demorar dependendo da conexão${NC}"
    read -p "Baixar wallpapers? (s/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        print_info "Wallpapers pulados"
        return 0
    fi
    
    local WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
    local TEMP_DIR="/tmp/wallpaper-temp"
    
    print_step "Baixando wallpapers..."
    if git clone https://github.com/JaKooLit/Wallpaper-Bank.git "$TEMP_DIR"; then
        mkdir -p "$(dirname "$WALLPAPER_DIR")"
        if [[ -d "$TEMP_DIR/wallpapers" ]]; then
            mv "$TEMP_DIR/wallpapers" "$WALLPAPER_DIR"
            print_success "Wallpapers instalados em: $WALLPAPER_DIR"
        else
            print_error "Pasta de wallpapers não encontrada"
        fi
        rm -rf "$TEMP_DIR"
    else
        print_error "Falha ao baixar wallpapers"
    fi
}

# ===== FUNÇÕES DE RELATÓRIO =====

# Função para mostrar resumo
show_summary() {
    print_header "📊 Relatório da Instalação"
    
    echo -e "${GREEN}✓ Sucesso:${NC} $SUCCESS_COUNT pacotes"
    echo -e "${YELLOW}⚠ Pulados:${NC} $SKIPPED_COUNT pacotes"
    
    if [[ ${#FAILED_PACKAGES[@]} -gt 0 ]]; then
        echo -e "\n${RED}❌ Pacotes com problemas:${NC}"
        printf '  %s\n' "${FAILED_PACKAGES[@]}"
    fi
    
    echo -e "\n${CYAN}📝 Log completo:${NC} $LOG_FILE"
}

# Função para perguntar reinicialização
ask_reboot() {
    print_header "🔄 Reinicialização"
    
    echo -e "${YELLOW}Recomenda-se reiniciar para aplicar todas as configurações${NC}"
    read -p "Reiniciar agora? (s/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        print_step "Reiniciando em 5 segundos..."
        for i in {5..1}; do
            echo -e "${YELLOW}$i...${NC}"
            sleep 1
        done
        print_success "Reiniciando!"
        sudo reboot
    else
        print_info "Execute 'sudo reboot' quando quiser reiniciar"
    fi
}

# ===== FUNÇÃO PRINCIPAL =====
main() {
    clear
    
    # Banner
    echo -e "${MAGENTA}"
    cat << "EOF"
    ╦ ╦╦ ╦╔═╗╦═╗  ╦╔╗╔╔═╗╔╦╗╔═╗╦  ╦  
    ╠═╣╚╦╝╠═╝╠╦╝  ║║║║╚═╗ ║ ╠═╣║  ║  
    ╩ ╩ ╩ ╩  ╩╚═  ╩╝╚╝╚═╝ ╩ ╩ ╩╩═╝╩═╝
     Hyprland Auto Installer - tutisFallen
EOF
    echo -e "${NC}"
    
    # Verificações iniciais
    check_root
    check_arch
    check_internet
    confirm_execution
    
    # Atualizar sistema
    print_header "🔄 Atualizando Sistema"
    sudo pacman -Syu --noconfirm
    
    # Instalar pacotes
    install_package_group "Pacotes Oficiais" PACOTES_OFICIAIS[@] "official"
    install_yay
    install_package_group "Pacotes AUR" PACOTES_AUR[@] "aur"
    
    # Configurações
    setup_hyprland
    enable_services
    install_sddm_theme
    download_wallpapers
    
    # Relatório final
    show_summary
    ask_reboot
}

# Executar
main