setenv CLICOLOR 1
setenv LSCOLORS ExGxcxdxCxegedabagacad
setenv TERM xterm-256color

alias ls 'ls --color=auto -N --show-control-chars'
alias pbcopy 'xsel -i -b'
alias pbpaste 'xsel -b'

bindkey "[Z" complete-word-back

eval `keychain --eval -q -Q --ignore-missing id_dsa id_rsa`

echo -n "\033]0;`uname -n`\007"
