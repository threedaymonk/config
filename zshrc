autoload -Uz colors; colors
autoload -Uz compinit; compinit

# Don't exit if I type ^D
setopt ignoreeof

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
setopt histignorealldups sharehistory
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
zstyle ':completion:*' matcher-list '' 'm:{a-z-}={A-Z_}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Various defaults
export EDITOR='vim'
export PAGER='less'
export GREP_OPTIONS='--exclude=\*.svn\*'
export TERM='xterm-256color'

alias ls='ls --color=auto -N --show-control-chars -G'
alias ll='ls -lah'
alias vim='vim -p'
alias youtube-dl='youtube-dl -t'
alias bx='bundle exec'
alias rvm='rvm.sh'
alias private='unset HISTFILE'

# Disable Ctrl-S, because why would you ever want that?
stty -ixon

# Default prompt colours
prompt_fg=black
prompt_bg=green

# Machine-specific settings
source ~/.zshrc.local

# Show stuff in prompt
precmd() {
  exit_status=$?

  if [ $HISTFILE ]; then
    fg=$prompt_fg
    bg=$prompt_bg
  else
    fg=$prompt_bg
    bg=$prompt_fg
  fi

  PS1="%F{$fg}%K{$bg} %(3~|[…]/|)%2~ >%b%f%k "

  if git branch >& /dev/null; then
    PS1="%F{black}%K{yellow} $(git branch --no-color | grep '^*' | cut -d ' ' -f 2-) ${PS1}"
  fi

  if [ $RUBY_VERSION ]; then
    PS1="%F{black}%K{white} ${RUBY_VERSION} ${PS1}"
  fi

  if test $exit_status -ne 0; then
    PS1="%F{white}%K{red} ${exit_status} ${PS1}"
  fi
}

bindkey "[Z" reverse-menu-complete
bindkey "[B" history-search-forward
bindkey "[A" history-search-backward

keychain -q -Q --ignore-missing id_dsa id_rsa
