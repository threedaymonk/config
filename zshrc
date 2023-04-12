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

# Show time taken for slow commands (over 30s)
REPORTTIME=30

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
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
if [ $VSCODE_GIT_IPC_HANDLE ]; then
  export GIT_EDITOR='code -w'
fi

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
alias xless='nohup xless >/dev/null 2>&1 &'
alias private='unset HISTFILE'
alias g=git

if [ $TMUX ]; then
  alias clear="$(/usr/bin/which clear); tmux clear"
fi

# Disable Ctrl-S, because why would you ever want that?
stty -ixon

# Default prompt colours
prompt_fg=black
prompt_bg=green

# Add or move directory to the front of PATH
prepend_path() {
  local to_add=$1
  export PATH=$to_add$( echo ":$PATH:" | sed 's!:$to_add:!:!' | sed 's!:$!!' )
}

# Heroku toolbelt
prepend_path "/usr/local/heroku/bin"

# I always want my ~/bin directory
prepend_path ~/bin

# Haskell
prepend_path ~/.cabal/bin

# Mono
prepend_path "/opt/mono/bin"

# Go
export GOPATH=~/.go
prepend_path $GOPATH/bin

# Show stuff in prompt
precmd() {
  local exit_status=$?
  local separator="%F{$prompt_bg}▕"

  if [ $HISTFILE ]; then
    fg=$prompt_fg
    bg=$prompt_bg
  else
    fg=$prompt_bg
    bg=$prompt_fg
  fi

  PS1="%F{$fg}%K{$bg} %(3~|[…]/|)%2~ >%b%f%k "

  if git branch >& /dev/null; then
    local branch="$(git branch --no-color | grep '^*' | cut -d ' ' -f 2-)"
    if [ "$branch" = "" ]; then
      local branch="(no branch)"
    fi
    if [[ "$branch" = "master" || "$branch" = "main" ]]; then
      local color=green
    else
      local color=yellow
    fi
    PS1="%F{black}%K{${color}} ${branch}${separator}${PS1}"
  fi

  if [ $RBENV_VERSION ]; then
    PS1="%F{black}%K{white} ${RBENV_VERSION}${separator}${PS1}"
  fi

  if test $exit_status -ne 0; then
    PS1="%F{white}%K{red} ${exit_status}${separator}${PS1}"
  fi
}

PS2="%F{$prompt_fg}%K{$prompt_bg}${PS2}%f%k"
PS3="%F{$prompt_fg}%K{$prompt_bg}${PS3}%f%k"
PS4="%F{$prompt_fg}%K{$prompt_bg}${PS4}%f%k"

bindkey "[Z" reverse-menu-complete
bindkey "[B" history-beginning-search-forward
bindkey "[A" history-beginning-search-backward
bindkey "OZ" reverse-menu-complete
bindkey "OB" history-beginning-search-forward
bindkey "OA" history-beginning-search-backward

if [ $DISPLAY ] && bin-exists gnome-keyring-daemon; then
  unset GNOME_KEYRING_CONTROL
  eval $(gnome-keyring-daemon --components=pkcs11,secret,ssh,gpg \
           --daemonize --start | \
           sed 's/^/export /')
fi

alias csi="rlwrap csi"

if [ -f ~/.asdf/asdf.sh ]; then
  source ~/.asdf/asdf.sh
  # append completions to fpath
  fpath=(${ASDF_DIR}/completions $fpath)
  # initialise completions with ZSH's compinit
  autoload -Uz compinit && compinit
fi

prepend_path "$HOME/.local/bin"

# Avoid typing bundle exec (in conjunction with binstubs)
# Bundle directory needs to be first for e.g. rake to work reliably
prepend_path "./.bundle/bin"

# Machine-specific settings
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
