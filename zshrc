autoload -Uz colors; colors
autoload -Uz compinit; compinit

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Various defaults
export EDITOR='vim'
export PAGER='less'
export GREP_OPTIONS='--exclude=\*.svn\*'

# Disable Ctrl-S, because why would you ever want that?
stty -ixon

# Show stuff in prompt
precmd() {
  exit_status=$?

  PS1="%F{black}%K{cyan} %(3~|[…]/|)%2~ >%b%f%k "

  if git branch >& /dev/null; then
    PS1="%F{black}%K{yellow} $(git branch --no-color | grep '^*' | cut -d ' ' -f 2) ${PS1}"
  fi

  if test $exit_status -ne 0; then
    PS1="%F{white}%K{red} ${exit_status} ${PS1}"
  fi
}

bindkey "[Z" reverse-menu-complete
bindkey "[B" history-search-forward
bindkey "[A" history-search-backward