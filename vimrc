" Use Plug to load bundles
" See https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
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
Plug 'vim-test/vim-test'
Plug 'https://github.com/github/copilot.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'preservim/nerdtree'
call plug#end()

" --- COMMON CONFIGURATION ---

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
autocmd VimEnter * set vb t_vb= " No more bell!

" Don't clutter working directory
set undodir=~/.cache/vim/
set backupdir=~/.cache/vim/
set directory=~/.cache/vim/

" --- KEYBOARD ---

" Use , instead of \ as the user modifier. Easier to reach.
let mapleader = ","
let maplocalleader = ","

" ,c runs makeprg
nmap <leader>c :w<CR>:make %<CR><CR>:copen<CR>

" Use Esc to exit terminal-mode
tnoremap <Esc> <C-\><C-n>

" Use Ctrl-J/K to move between tabs
:nmap <C-J> :tabprevious<cr>
:nmap <C-K> :tabnext<cr>
:map  <C-J> :tabprevious<cr>
:map  <C-K> :tabnext<cr>
:imap <C-J> <ESC>:tabprevious<cr>i
:imap <C-K> <ESC>:tabnext<cr>i

" Use Ctrl-X to close a tab
:map <C-X> :bd<CR>

" Use Ctrl-N for :cnext
:nmap <C-N> :cnext<CR>
:map  <C-N> :cnext<CR>

" Use Alt-H/J/K/L to move between windows
tnoremap <A-h> <C-\><C-N><C-w>h
tnoremap <A-j> <C-\><C-N><C-w>j
tnoremap <A-k> <C-\><C-N><C-w>k
tnoremap <A-l> <C-\><C-N><C-w>l
inoremap <A-h> <C-\><C-N><C-w>h
inoremap <A-j> <C-\><C-N><C-w>j
inoremap <A-k> <C-\><C-N><C-w>k
inoremap <A-l> <C-\><C-N><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

" --- CTRLP ---

let g:ctrlp_user_command = {
	\ 'types': {
		\ 1: ['.git', 'cd %s && git ls-files'],
		\ 2: ['.hg', 'hg --cwd %s locate -I .'],
		\ },
	\ 'fallback': 'find %s -type f'
	\ }

" --- FUGITIVE ---

command! -nargs=+ -complete=file GG silent Ggrep! <args> | copen

" --- VIM-TEST ---

let test#strategy = "neovim"
" Use normal terminal window that doesn't disappear on a keypress
let g:test#neovim#start_normal = 1
nmap <silent> <leader>T :TestNearest<CR>
nmap <silent> <leader>t :TestFile<CR>

" --- FILETYPE-SPECIFIC CONFIGURATION ---

autocmd BufNewFile,BufReadPost *_spec.rb setl filetype=rspec syntax=ruby
autocmd BufNewFile,BufReadPost *.make setl filetype=make syntax=make

" Makefiles
autocmd FileType make setl noet | setl ts=8 | setl sw=8

" Python
autocmd FileType python
  \ setl ts=4 | setl sw=4 " PEP8

" Keywords
autocmd FileType css,scss,clojure,scheme setl isk+=-

" Ruby
autocmd FileType ruby
  \ set makeprg=ruby\ -cw|
  \ setl isk+=\?,!

" Javascript
autocmd FileType javascript
  \ set makeprg=jshint

" Shell scripts
autocmd FileType sh
  \ set makeprg=shellcheck

" Go
autocmd FileType go
  \ setl noet | setl ts=4 | setl sw=4 |
  \ autocmd BufWritePre <buffer> Fmt
