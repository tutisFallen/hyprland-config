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
setopt autocd

# aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -lha'
