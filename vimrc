" Use Plug to load bundles
" See https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-abolish'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-cucumber'
Plug 'editorconfig/editorconfig-vim'
Plug 'elixir-lang/vim-elixir'
Plug 'gitgutter/Vim'
Plug 'fatih/vim-go'
Plug 'hallison/vim-markdown'
Plug 'ReekenX/vim-rename2'
Plug 'vim-ruby/vim-ruby'
Plug 'nanki/treetop.vim'
Plug 'vim-scripts/VimClojure'
Plug 'sirtaj/vim-openscad'
Plug 'sersorrel/vim-lilypond'
Plug 'kburdett/vim-nuuid'
Plug 'tidalcycles/vim-tidal'
Plug 'junegunn/vim-easy-align'
call plug#end()

" Get a good value for $PATH.
let $PATH = system("printenv PATH")
let $PATH = substitute($PATH, "\<C-J>$", "", "")

" General defaults
set nocompatible
filetype on
filetype plugin on
syntax on " Syntax highlighting
set ai " Auto-indent
set et " Expand tabs to spaces
set ts=2
set sw=2
set nu " Line numbers on
set backspace=2 " Fully-functional interactive backspace
set isk+=_ " Not word dividers
set wildmenu " : Auto completion
set showcmd " show current command in status bar
set showmatch " show matching parenthesis etc.
set hidden
set ruler
set scrolloff=3
if exists("&colorcolumn")
  set colorcolumn=80
end
set encoding=utf-8
set fileencoding=utf-8
set incsearch " Show first match when typing a search

" Override default tab settings for some filetypes
autocmd FileType make setl noet | setl ts=8 | setl sw=8
autocmd FileType python setl ts=4 | setl sw=4 " PEP 8
autocmd BufNewFile,BufReadPost *.tsv setl noet | setl ts=16 | setl sw=16
autocmd FileType go setl noet | setl ts=4 | setl sw=4
autocmd BufNewFile,BufReadPost *.text.erb setl tw=72 " Wrap emails at 72 cols

" Highlight tabs (if expandtab is set)
autocmd BufNewFile,BufReadPost *
  \ if &expandtab |
  \   syn match Tab "\t" |
  \ endif

" Highlight whitespace errors
autocmd BufNewFile,BufReadPost * syn match TrailingWS "\s\+$"

" Mouse support under tmux
set mouse=a

set t_Co=256

" For use on a dark terminal
set background=dark

runtime! indent.vim
runtime! macros/matchit.vim " Use % to match if/end etc.

" Use , instead of \ as the user modifier. Easier to reach.
let mapleader = ","
let maplocalleader = ","

" Use ^J/^K to move between tabs
:nmap <C-J> :tabprevious<cr>
:nmap <C-K> :tabnext<cr>
:map  <C-J> :tabprevious<cr>
:map  <C-K> :tabnext<cr>
:imap <C-J> <ESC>:tabprevious<cr>i
:imap <C-K> <ESC>:tabnext<cr>i

" Use ^X to close a tab
:map <C-X> :bd<CR>

" Use ^N for :cnext
:nmap <C-N> :cnext<CR>
:map  <C-N> :cnext<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Remember where the cursor was last time we edited this file, and jump there
" on opening
augroup JumpCursorOnEdit
  au!
  autocmd BufReadPost *
    \ if &syntax != 'gitcommit' && expand("<afile>:p:h") !=? $TEMP |
    \   if line("'\"") > 1 && line("'\"") <= line("$") |
    \     let JumpCursorOnEdit_foo = line("'\"") |
    \     let b:doopenfold = 1 |
    \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
    \        let JumpCursorJOnEdit_foo = JumpCursorOnEdit_foo - 1 |
    \        let b:doopenfold = 2 |
    \     endif |
    \     exe JumpCursorOnEdit_foo |
    \   endif |
    \ endif
  " Need to postpone using "zv" until after reading the modelines.
  autocmd BufWinEnter *
    \ if exists("b:doopenfold") |
    \   exe "normal zv" |
    \   if(b:doopenfold > 1) |
    \       exe  "+".1 |
    \   endif |
    \   unlet b:doopenfold |
    \ endif
augroup END

let Tlist_Show_One_File = 1

" Run a shell command in a new window
command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1,a:cmdline)
  call setline(2,substitute(a:cmdline,'.','=','g'))
  execute 'silent $read !'.escape(a:cmdline,'%#')
  setlocal nomodifiable
  1
endfunction
command! -complete=file -nargs=* Git call s:RunShellCommand('git '.<q-args>)
command! -complete=file -nargs=* Svn call s:RunShellCommand('svn '.<q-args>)

" An Ack command
function! Ack(args)
  let grepprg_bak=&grepprg
  set grepprg=ack\ -H\ --nocolor\ --nogroup\ --ignore-dir=coverage\ --ignore-dir=tmp\ --ignore-dir=log
  execute "silent! grep " . a:args
  botright copen
  let &grepprg=grepprg_bak
endfunction
command! -nargs=* -complete=file Ack call Ack(<q-args>)

" Search with git grep
function! GG(args)
  let grepprg_bak=&grepprg
  set grepprg=git\ grep\ --no-color\ --line-number
  execute "silent! grep " . a:args
  botright copen
  let &grepprg=grepprg_bak
endfunction
command! -nargs=* -complete=file GG call GG(<q-args>)

" Run a shell command and put its output in a quickfix buffer
let g:command_output=".quickfix.tmp"
function! s:RunShellCommandToQuickfix(cmdline)
  -tabedit %
  execute 'terminal '.a:cmdline.' | ansitee -s '.g:command_output
endfunction
command! -nargs=+ -complete=command ToQF call s:RunShellCommandToQuickfix(<q-args>)

" Line up stuff in visual mode
vmap <leader>l=  :!$HOME/.vim/bin/line-up-equals<CR>
vmap <leader>l,  :!$HOME/.vim/bin/line-up-commas<CR>
vmap <leader>l\| :!$HOME/.vim/bin/tableify<CR>

" Various useful Ruby command mode shortcuts
" focused-test can be found at http://github.com/btakita/focused-test
let g:ruby="ruby -Itest"
autocmd FileType ruby
  \ nmap <buffer> <leader>r :w<CR>:ToQF <C-R>=g:ruby<CR> %<CR>|
  \ nmap <buffer> <leader>c :w<CR>:ToQF <C-R>=g:ruby<CR> -c %<CR>

let g:rspec="rspec --color --tty"
autocmd FileType rspec
  \ nmap <buffer> <leader>r :w<CR>:ToQF <C-R>=g:rspec<CR> %<CR>|
  \ nmap <buffer> <leader>R :w<CR>:ToQF <C-R>=g:rspec<CR> %\:<C-R>=line(".")<CR><CR>|
  \ setlocal errorformat=rspec\ %f:%l\ #\ %m

let g:cucumber="cucumber -r features --color"
autocmd FileType cucumber
  \ nmap <buffer> <leader>r :w<CR>:ToQF <C-R>=g:cucumber<CR> %<CR>|
  \ nmap <buffer> <leader>R :w<CR>:ToQF <C-R>=g:cucumber<CR> %\:<C-R>=line(".")<CR><CR>|
set errorformat+=cucumber\ %f:%l\ %m

autocmd FileType haskell
  \ nmap <buffer> <leader>c :w<CR>:!hlint % && ghc -fno-code %<CR>|
  \ nmap <buffer> <leader>r :w<CR>:ToQF runhaskell %<CR>

autocmd FileType javascript
  \ nmap <buffer> <leader>c :w<CR>:ToQF jshint %<CR>|
  \ setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m

autocmd FileType sh
  \ nmap <buffer> <leader>c :w<CR>:ToQF shellcheck %<CR>

" Additional filetypes
autocmd BufNewFile,BufReadPost *.json setl filetype=javascript
autocmd BufNewFile,BufReadPost *.rabl setl filetype=ruby
autocmd BufNewFile,BufReadPost *_spec.rb setl filetype=rspec syntax=ruby
autocmd BufNewFile,BufReadPost *.make setl filetype=make syntax=make

" Use hyphens in identifiers in some languages
autocmd BufNewFile,BufReadPost *.css,*.scss,*.clj,*.scm setl isk+=-

" Use question and exclamation marks in identifiers in Ruby
autocmd FileType ruby setl isk+=\?,!

" Rainbow parens in Clojure
let g:vimclojure#ParenRainbow = 1
let g:vimclojure#ParenRainbowColorsDark = {
  \ '1': 'ctermfg=magenta',
  \ '2': 'ctermfg=red',
  \ '3': 'ctermfg=yellow',
  \ '4': 'ctermfg=green',
  \ '5': 'ctermfg=cyan',
  \ '6': 'ctermfg=magenta',
  \ '7': 'ctermfg=red',
  \ '8': 'ctermfg=yellow',
  \ '9': 'ctermfg=green'
  \ }
let g:vimclojure#HighlightBuiltins = 1
let g:vimclojure#WantNailgun = 1

" Rainbow parens in Scheme
autocmd FileType scheme
  \ syn region level1 matchgroup=level1c start=/(/ end=/)/ contains=TOP,level1,level2,level3,level4,level5,NoInParens |
  \ syn region level2 matchgroup=level2c start=/(/ end=/)/ contains=TOP,level2,level3,level4,level5,NoInParens |
  \ syn region level3 matchgroup=level3c start=/(/ end=/)/ contains=TOP,level3,level4,level5,NoInParens |
  \ syn region level4 matchgroup=level4c start=/(/ end=/)/ contains=TOP,level4,level5,NoInParens |
  \ syn region level5 matchgroup=level5c start=/(/ end=/)/ contains=TOP,level5,NoInParens

" Autoformat Go files on save
autocmd FileType go autocmd BufWritePre <buffer> Fmt

" ,v will open <C-R>=g:command_output<CR> as a cross-reference window
nmap <leader>v :cfile <C-R>=g:command_output<CR><CR>:copen<CR>

" ,a to open a new tab with :Ack ready to go
nmap <leader>a :tabe<CR>:Ack 

" No more bell!
autocmd VimEnter * set vb t_vb=

" If there's a local .vimrc file, use it
" Avoid infinite recursion by skipping this if we're in $HOME
function! SourceVimLocal()
  if filereadable(".vimrc") && (expand($HOME) != getcwd())
    source .vimrc
  endif
endfunction
call SourceVimLocal()

" X11 copy/paste integration
map <leader>pc :w !xsel -i -b<CR>
nmap <leader>pv :r!xsel -b<CR>

set wildignore+=*/.bundle/*,*/coverage/*,*.class

let g:ctrlp_user_command = {
	\ 'types': {
		\ 1: ['.git', 'cd %s && git ls-files'],
		\ 2: ['.hg', 'hg --cwd %s locate -I .'],
		\ },
	\ 'fallback': 'find %s -type f'
	\ }

let g:mta_use_matchparen_group = 0
let g:mta_set_default_matchtag_color = 0
let g:mta_filetypes = { 'html' : 1, 'xhtml' : 1, 'xml' : 1, 'eruby' : 1 }

set undodir=~/.cache/vim/
set backupdir=~/.cache/vim/
set directory=~/.cache/vim/

" Use neovim terminal for TidalCycles
let g:tidal_target = "terminal"
