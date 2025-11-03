# ~/.zshrc
autoload -U colors && colors

# função pra mostrar última pasta ou "Home" se estiver no ~
prompt_dir() {
  if [[ $PWD == $HOME ]]; then
    echo "Home"
  else
    basename "$PWD"
  fi
}

# prompt colorido dinâmico
set_prompt() {
  PROMPT="%B%F{green}%n%f%b@%F{red}%m%f %F{blue}%*%f ~> %F{yellow}$(prompt_dir)%f %F{green}~>%f "
}

# atualizar prompt a cada comando
autoload -U add-zsh-hook
add-zsh-hook precmd set_prompt

# histórico e autocompletar
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
autoload -Uz compinit && compinit

# Configurações básicas de autocompletar
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# ========== INTEGRAÇÃO COM FZF ==========
# Verifica se fzf está instalado
if command -v fzf >/dev/null 2>&1; then
    # Configurações do FZF
    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "echo {}" --color=bg+:#3b3b3b,bg:#323232,spinner:#fb4934,hl:#928374,fg:#d5c4a1,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#d5c4a1,prompt:#fb4934,hl+:#fb4934'
    
    # Completar com fzf
    export FZF_COMPLETION_TRIGGER='**'
    
    # Usar fzf para completar arquivos e diretórios
    _fzf_compgen_path() {
      fd --hidden --follow --exclude ".git" . "$1"
    }
    
    _fzf_compgen_dir() {
      fd --type d --hidden --follow --exclude ".git" . "$1"
    }
    
    # Ativar completar com fzf (carrega arquivos oficiais se existirem)
    for file in /usr/share/fzf/shell/key-bindings.zsh /usr/share/doc/fzf/examples/key-bindings.zsh /opt/homebrew/opt/fzf/shell/key-bindings.zsh; do
        if [[ -f "$file" ]]; then
            source "$file"
            break
        fi
    done
    
    # Aliases para fzf
    alias fzf='fzf --preview "bat --color=always --style=numbers {} 2>/dev/null || ls -la {}"'
    alias fzfcd='cd $(find . -type d 2>/dev/null | fzf)'
    alias fzfhist='history | fzf'
    alias fzffiles='fd --type f --hidden --exclude .git | fzf --preview "bat --color=always --style=numbers {} 2>/dev/null || cat {}"'
    alias fzfdirs='fd --type d --hidden --exclude .git | fzf --preview "ls -la {}"'
    
    # Completar histórico de comandos com fzf (Ctrl+R já vem por padrão)
    fzf-history-widget() {
      local selected=$(history -n 1 | fzf --tac --no-sort --query="$LBUFFER")
      if [[ -n "$selected" ]]; then
        LBUFFER="$selected"
      fi
      zle reset-prompt
    }
    zle -N fzf-history-widget
    bindkey '^R' fzf-history-widget
    
    # Completar arquivos com preview (usando Ctrl+T - padrão do fzf)
    fzf-file-widget() {
      local selected=$(fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always --style=numbers {} 2>/dev/null || cat {}')
      if [[ -n "$selected" ]]; then
        LBUFFER="$LBUFFER$selected"
      fi
      zle reset-prompt
    }
    zle -N fzf-file-widget
    bindkey '^T' fzf-file-widget
    
    # Completar diretórios com preview (usando Alt+C)
    fzf-dir-widget() {
      local selected=$(fd --type d --hidden --exclude .git | fzf --preview 'ls -la {}')
      if [[ -n "$selected" ]]; then
        # Se o LBUFFER estiver vazio, muda diretório, senão insere o caminho
        if [[ -z "$LBUFFER" ]]; then
          cd "$selected"
          zle reset-prompt
        else
          LBUFFER="$LBUFFER$selected"
          zle redisplay
        fi
      else
        zle redisplay
      fi
    }
    zle -N fzf-dir-widget
    bindkey '^[c' fzf-dir-widget  # Alt+C
    
    # Pesquisar e abrir arquivo com VS Code (Ctrl+E)
    fzf-edit-widget() {
      local selected=$(fd --type f --hidden --exclude .git | fzf --preview 'bat --color=always --style=numbers {} 2>/dev/null || cat {}')
      if [[ -n "$selected" ]]; then
        BUFFER="code \"$selected\""
        zle accept-line
      fi
      zle reset-prompt
    }
    zle -N fzf-edit-widget
    bindkey '^E' fzf-edit-widget
    
    # Abrir pasta no VS Code (Alt+V)
    fzf-code-folder-widget() {
      local selected=$(fd --type d --hidden --exclude .git | fzf --preview 'ls -la {}')
      if [[ -n "$selected" ]]; then
        BUFFER="code \"$selected\""
        zle accept-line
      fi
      zle reset-prompt
    }
    zle -N fzf-code-folder-widget
    bindkey '^[v' fzf-code-folder-widget  # Alt+V
fi

# Opções úteis
setopt autocd
setopt hist_ignore_dups

# aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'

# Editor padrão - VS Code
export EDITOR='code'

# Aliases para VS Code
alias c='code .'
alias codehere='code .'

# Abrir arquivo no VS Code
codef() {
  if [[ $# -eq 0 ]]; then
    code .
  else
    code "$@"
  fi
}

# Melhorar o completar do cd
zstyle ':completion:*' special-dirs true