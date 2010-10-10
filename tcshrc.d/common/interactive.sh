setenv EDITOR vim
setenv PAGER less
setenv GREP_OPTIONS '--exclude=\*.svn\*'

set color
set complete = enhance
bindkey "	" complete-word-fwd
bindkey -k down history-search-forward
bindkey -k up history-search-backward
set dspmbyte = "utf8"

alias ll 'ls -lah'
alias vim 'vim -p'
alias youtube-dl 'youtube-dl -t'

set nobeep
set fignore=(.o)

set ignoreeof
set notify
set noclobber

set history = 250
set histfile = "$HOME/.history"
set savehist = ( 125 merge )
