" Get a good value for $PATH.
let $PATH = system("printenv PATH")
let $PATH = substitute($PATH, "\<C-J>$", "", "")

" If running in a terminal window, set the terminal type to allow syntax
" highlighting. Otherwise, change directory on startup.
if !has("gui_running")
  set term=ansi
else
  autocmd VimEnter * if getcwd()=="/" | if strlen(@%) | cd %:p:h | else | cd | endif | endif
endif

set nocompatible
filetype on
syntax on " Syntax highlighting
set ai " Auto-indent
set et " Expand tabs to spaces
autocmd BufRead,BufNewFile,BufEnter Makefile* set noet " ... except for a Makefile
autocmd BufRead,BufNewFile,BufEnter *.tsv set noet " ... or a tab-separated-value file
set ts=2
set sw=2
autocmd BufRead,BufNewFile,BufEnter *.py set ts=4 | set sw=4 " Follow PEP 8 for Python source
set nu " Line numbers on
set backspace=2 " Fully-functional interactive backspace
set isk+=_,$,@,%,# " Not word dividers
set wildmenu " : Auto completion
set showcmd " show current command in status bar
set showmatch " show matching parenthesis etc.
set hidden
set ruler
set scrolloff=3

" For use on a dark terminal
set background=dark
set t_Co=256
colorscheme vividchalk

runtime! indent.vim
runtime! macros/matchit.vim " Use % to match if/end etc.

" Use , instead of \ as the user modifier. Easier to reach.
let mapleader = ","

" Use ^J/^K to move between tabs
:nmap <C-J> :tabprevious<cr>
:nmap <C-K> :tabnext<cr>
:map  <C-J> :tabprevious<cr>
:map  <C-K> :tabnext<cr>
:imap <C-J> <ESC>:tabprevious<cr>i
:imap <C-K> <ESC>:tabnext<cr>i

" Use ^N for :cnext
:nmap <C-N> :cnext<CR>
:map  <C-N> :cnext<CR>

" Remember where the cursor was last time we edited this file, and jump there
" on opening
augroup JumpCursorOnEdit
  au!
  autocmd BufReadPost *
    \ if expand("<afile>:p:h") !=? $TEMP |
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

set encoding=utf-8
set fileencoding=utf-8

let Tlist_Show_One_File = 1

augroup HighlightPeskyTabs
  au!
  autocmd BufRead,BufNewFile *
      \ syn match Tab "\t" |
      \ syn match TrailingWS "\s\+$" |  
      \ if &background == "dark" |
      \   hi def Tab ctermbg=red guibg=#220000 |
      \   hi def TrailingWS ctermbg=red guibg=#220000 |
      \ else |
      \   hi def Tab ctermbg=red guibg=#ffdddd |
      \   hi def TrailingWS ctermbg=red guibg=#ffdddd |
      \ endif
augroup END

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
command! -complete=file -nargs=* Svn call s:RunShellCommand('svn '.<q-args>)

function! Ack(args)
  let grepprg_bak=&grepprg
  set grepprg=ack\ -H\ -a\ --nocolor\ --nogroup\ --ignore-dir=coverage\ --ignore-dir=tmp\ --ignore-dir=log
  execute "silent! grep " . a:args
  botright copen
  let &grepprg=grepprg_bak
endfunction

command! -nargs=* -complete=file Ack call Ack(<q-args>)

" Run a shell command and put its output in a quickfix buffer
function! s:RunShellCommandToQuickFix(cmdline)
  execute '!'.escape(a:cmdline.' | tee /tmp/output.txt','%#')
  1
endfunction
command! -nargs=* Rake call s:RunShellCommandToQuickFix('rake '.<q-args>)

" Line up stuff in visual mode
vmap =  :!$HOME/.vim/bin/line-up-equals<CR>
vmap ,  :!$HOME/.vim/bin/line-up-commas<CR>
vmap \| :!$HOME/.vim/bin/tableify<CR>

" http://tammersaleh.com/posts/quick-vim-svn-blame-snippet
vmap gl :<C-U>!svn blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" Various useful Ruby command mode shortcuts
" focused-test can be found at http://github.com/btakita/focused-test
augroup Ruby
  au!
  autocmd BufRead,BufNewFile,BufEnter *_test.rb,test_*.rb,*_spec.rb
    \ :nmap <leader>R V:<C-U>!focused-test -b -f % -l <C-R>=line(".")<CR> \| tee /tmp/output.txt<CR>
  autocmd BufRead,BufNewFile,BufEnter *.rb
    \ :nmap <leader>r :<C-U>!ruby % \| tee /tmp/output.txt<CR>|
    \ :nmap <leader>c :<C-U>!ruby -c % \| tee /tmp/output.txt<CR>|
    \ :vmap b :!beautify-ruby<CR>|
    \ :imap emd end
  autocmd BufRead,BufNewFile,BufEnter *_spec.rb
    \ :nmap <leader>r :<C-U>!spec % \| tee /tmp/output.txt<CR>
augroup END

augroup RHTML
  au!
  autocmd BufRead,BufNewFile,BufEnter *.rhtml,*.html.erb
    \ :vmap b :!htmlbeautifier<CR>
augroup END

augroup Cucumber
  au!
  autocmd BufNewFile,BufReadPost,BufEnter *.feature,*.story
    \ set filetype=cucumber|
    \ :nmap <leader>r :<C-U>!cucumber-runner %<CR>|
    \ :nmap <leader>R :<C-U>!cucumber-runner -b %\:<C-R>=line(".")<CR><CR>
augroup END

autocmd BufNewFile,BufReadPost,BufEnter *.json set filetype=javascript

nmap <leader>v :cfile /tmp/output.txt<CR>:copen<CR>

" No more bell!
autocmd VimEnter * set vb t_vb=
