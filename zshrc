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

bin-exists() {
  /usr/bin/which $1 >/dev/null
}

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
if bin-exists dircolors; then
  eval "$(dircolors -b)"
fi
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

# Set DICT to the British dictionary from 12dicts, if it exists
if [ -e /opt/12dicts/ ]; then
  export DICT=/opt/12dicts/2of4brif.txt
fi

if ls --color=auto >/dev/null 2>&1; then
  alias ls='ls --color=auto -N --show-control-chars'
else
  alias ls='ls -G'
fi
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

# Add directory to PATH if it exists and is not already there.
prepend_path() {
  to_add=$1
  if [ -d $to_add ] && ( ! echo ":$PATH:" | grep -qF ":$to_add:" ); then
    export PATH=$to_add:$PATH
  fi
}

# I always want my ~/bin directory
prepend_path ~/bin

# Machine-specific settings
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

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

PS2="%F{$prompt_fg}%K{$prompt_bg}${PS2}%f%k"
PS3="%F{$prompt_fg}%K{$prompt_bg}${PS3}%f%k"
PS4="%F{$prompt_fg}%K{$prompt_bg}${PS4}%f%k"

# Use pry for 'irb' if present
irb() {
  if bin-exists pry; then
    pry "$@";
  else
    $(/usr/bin/which irb) "$@";
  fi
}

bindkey "[Z" reverse-menu-complete
bindkey "[B" history-beginning-search-forward
bindkey "[A" history-beginning-search-backward

if [ $DISPLAY ] && bin-exists gnome-keyring-daemon; then
  eval $(gnome-keyring-daemon --daemonize --start)
fi

if bin-exists xdg-open; then
  alias open=xdg-open
fi
