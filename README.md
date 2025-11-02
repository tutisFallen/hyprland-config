# 🚀 HYPR - Minha Configuração do Hyprland

<div align="center">

![Hyprland](https://img.shields.io/badge/Hyprland-Dynamic%20Tiling-blue?style=for-the-badge&logo=wayland)
![Material Shell](https://img.shields.io/badge/Shell-Material%20Shell-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)

*Uma configuração limpa e funcional para Hyprland com Material Shell* ✨

</div>

---

## 📋 Sobre

Esta é minha configuração pessoal do **Hyprland**, um compositor Wayland dinâmico e moderno. Ao invés de usar Waybar ou outras barras tradicionais, utilizo o **[Dank Material Shell](https://github.com/AvengeMedia/DankMaterialShell)** para uma experiência única e produtiva.

## 🎯 Estrutura

```
HYPR/
├── configs/              # 📁 Configurações principais
│   ├── autostart.conf    # 🚀 Aplicativos e serviços na inicialização
│   ├── colors.conf       # 🎨 Esquema de cores
│   ├── hyprlock.conf     # 🔒 Configuração do lock screen
│   ├── hyprpaper.conf    # 🖼️ Configuração do wallpaper
│   ├── input.conf        # ⌨️ Dispositivos de entrada (mouse/teclado)
│   ├── keybinds.conf     # ⚡ Atalhos de teclado
│   ├── rules.conf        # 📐 Regras de janelas
│   ├── variables.conf    # 🔧 Variáveis de ambiente
│   ├── visuals.conf      # 👁️ Efeitos visuais e animações
│   └── workspaces.conf   # 🗂️ Configuração de workspaces
├── scripts/              # 📜 Scripts auxiliares
├── hyprland.conf         # ⚙️ Arquivo principal (importa configs/)
├── monitors.conf         # 🖥️ Configuração de monitores (nwg-displays)
└── README.md             # 📖 Este arquivo
```

## ⚙️ Características

- **🎨 Configuração Modular**: Cada aspecto em seu próprio arquivo para fácil manutenção
- **🖥️ Multi-Monitor**: Gerenciado via `nwg-displays` com configuração automática
- **🎭 Material Shell**: Interface moderna e produtiva sem Waybar
- **🚀 Otimizado**: Configurações pensadas para performance e workflow eficiente
- **🔒 Segurança**: Hyprlock configurado para screen locking
- **🖼️ Hyprpaper**: Gerenciamento de wallpapers integrado
- **🌈 Cores Dinâmicas**: Esquema de cores gerado automaticamente via `matugen` baseado no wallpaper

## 📦 Dependências

### Essenciais
```bash
# Compositor e shell
hyprland
dank-material-shell-git  # https://github.com/AvengeMedia/DankMaterialShell
                        # (já inclui matugen para cores dinâmicas)

# Display Manager e Tema
sddm                    # Display manager
sddm-astronaut-theme    # Tema espacial para SDDM (opcional)

# Utilitários
nwg-displays            # Gerenciamento de monitores
hyprlock               # Screen locker
hyprpaper              # Wallpaper daemon
```

### Recomendadas
```bash
# Terminal e ferramentas
kitty                  # Terminal (ou seu preferido)
wofi                   # Application launcher
dunst                  # Notificações
grim                   # Screenshots
slurp                  # Seleção de área
wl-clipboard          # Clipboard para Wayland
```

## 🚀 Instalação

### Instalação Automática (Recomendado) ⚡

O método mais fácil e rápido! Nosso script automatizado vai fazer tudo por você:

```bash
# Baixe e execute o script de instalação
curl -fsSL https://raw.githubusercontent.com/tutisFallen/hypr/main/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

**O que o script faz:**
- ✅ Atualiza seu sistema
- ✅ Instala `yay` (se necessário)
- ✅ Instala todos os pacotes necessários (oficiais + AUR)
- ✅ Clona este repositório
- ✅ Faz backup da sua configuração antiga (se existir)
- ✅ Copia as novas configurações para `~/.config/hypr`
- ✅ Ativa serviços necessários (Bluetooth, SDDM)
- ✅ Instala o tema SDDM Astronaut 🚀
- ✅ Oferece reinicialização automática

**Tratamento de Erros:**
- Se algum pacote falhar, você pode escolher pular e continuar
- Mostra um resumo completo no final
- Backup automático de configs antigas

---

### Instalação Manual 🔧

Se preferir ter mais controle sobre o processo:

1. **Clone este repositório**
```bash
git clone https://github.com/tutisFallen/hypr.git ~/.config/hypr
```

2. **Instale as dependências** (veja seção abaixo)
```bash
nwg-displays
# Após configurar, copie a saída para monitors.conf
```

3. **Inicie o Hyprland**
```bash
Hyprland
```

## ⚡ Atalhos Principais

> Verifique `configs/keybinds.conf` para a lista completa de atalhos!

| Atalho | Ação |
|--------|------|
| `SUPER + Return` | Abrir terminal |
| `SUPER + Q` | Fechar janela |
| `SUPER + Space` | Launcher |
| `SUPER + ALT + L` | 🔒 Bloquear tela |
| `SUPER + [1-9]` | Trocar workspace |

## 🎨 Personalização

### Cores
As cores são geradas **automaticamente** pelo `matugen` (incluído no Dank Material Shell) baseado no seu wallpaper! 🎨

Quando você muda o papel de parede, o `matugen` extrai as cores dominantes e atualiza todo o tema automaticamente. O arquivo `configs/colors.conf` é gerado dinamicamente.

### Monitores
Use `nwg-displays` para configurar visualmente seus monitores:
```bash
nwg-displays
```
As configurações serão salvas em `monitors.conf`.

### Autostart
Adicione seus programas em `configs/autostart.conf`.

### Keybinds
Customize seus atalhos em `configs/keybinds.conf`.

## 🖥️ Multi-Monitor Setup

O arquivo `monitors.conf` é gerenciado pelo **nwg-displays**, que oferece uma interface gráfica intuitiva para:
- ✅ Configurar resoluções
- ✅ Ajustar posicionamento
- ✅ Definir taxas de atualização
- ✅ Configurar escala (scaling)

## 🤝 Créditos

- [Hyprland](https://hyprland.org/) - O compositor Wayland
- [Dank Material Shell](https://github.com/AvengeMedia/DankMaterialShell) - Interface moderna
- [nwg-displays](https://github.com/nwg-piotr/nwg-displays) - Gerenciador de monitores
- [SDDM Astronaut Theme](https://github.com/keyitdev/sddm-astronaut-theme) - Tema espacial para login

## 📝 Notas

- Esta configuração **não usa Waybar** - todo o gerenciamento de interface é feito pelo Material Shell
- Os scripts na pasta `scripts/` são auxiliares personalizados
- O tema SDDM Astronaut é opcional mas altamente recomendado 🚀
- O script de instalação faz backup automático de configurações antigas
- Certifique-se de ter todas as dependências instaladas para funcionamento completo

## 🐛 Problemas Conhecidos

Se encontrar algum problema durante a instalação:
- Verifique se seu sistema está atualizado: `sudo pacman -Syu`
- Certifique-se de ter `git` instalado
- Para problemas com pacotes AUR, tente instalar `yay` manualmente primeiro
- Abra uma [issue no GitHub](https://github.com/tutisFallen/hypr/issues) se o problema persistir

## 📄 Licença

Configuração pessoal - use e modifique como quiser! 🎉

---

<div align="center">

**Feito com ❤️ e Hyprland**

*Se gostou, deixe uma ⭐!*

</div>