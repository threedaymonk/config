setenv CLICOLOR 1
setenv LSCOLORS ExGxcxdxCxegedabagacad

alias ls 'ls --color=auto -N --show-control-chars'
alias pbcopy 'xsel -i -b'
alias pbpaste 'xsel -b'

bindkey "[Z" complete-word-back

test -r "${HOME}/.ssh/id_dsa" && keychain -q -Q id_dsa
test -r "${HOME}/.ssh/id_rsa" && keychain -q -Q id_rsa

echo -n "\033]0;`uname -n`\007"
