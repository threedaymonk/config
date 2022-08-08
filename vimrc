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
Plug 'github/copilot.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'stevearc/aerial.nvim'
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
set statusline=%<%f\ %h%m%r\ %y\ %{FugitiveStatusline()}%=\ %-14.(%l/%L\ %c%V\ U+%04B%)\ %P

" Don't clutter working directory
set undodir=~/.cache/vim/
set backupdir=~/.cache/vim/
set directory=~/.cache/vim/

" X11 copy/paste integration
map <leader>pc :w !xclip -i -selection clipboard<CR>
nmap <leader>pv :r!xclip -o -selection clipboard<CR>

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

" -- NETRW BROWSER ---

" Invoke with :Vex
let g:netrw_liststyle = 3 " tree-style listing
let g:netrw_browse_split = 4 " open files in previous window to right
let g:netrw_winsize = 25 " limit to 25% width
let g:netrw_banner = 0 " no banner
let g:netrw_list_hide = &wildignore " hide files matching wildignore

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

" --- COPILOT ---

let g:copilot_filetypes = {
  \ 'text': v:false,
  \ 'markdown': v:false,
  \ }

" --- TREESITTER ---

lua <<LUA
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    "c", "cpp", "css", "html", "javascript", "json", "latex", "ruby", "scss",
    "sql"
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
LUA

" --- AERIAL ---

lua <<LUA
require('aerial').setup({
  default_direction = "prefer_left",
  width = 0.25,
})
LUA

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
  \ setl makeprg=ruby\ -cw|
  \ setl isk+=\?,!

" Javascript
autocmd FileType javascript
  \ setl makeprg=jshint

" Shell scripts
autocmd FileType sh
  \ setl makeprg=shellcheck

" Go
autocmd FileType go
  \ setl noet | setl ts=4 | setl sw=4 |
  \ autocmd BufWritePre <buffer> Fmt

" --- SESSION ---

" Save the current session iff there's an existing session file, i.e. I have to
" type :mks! at least once to indicate that I care about this project.
function! SaveSession()
  if filereadable(getcwd() . "/Session.vim")
    execute 'mksession! ' . getcwd() . '/Session.vim'
  endif
endfunction

function! RestoreSession()
  if filereadable(getcwd() . '/Session.vim') && bufname() !~ '\.git/'
    execute 'source ' . getcwd() . '/Session.vim'
    if bufexists(1)
      for l in range(1, bufnr('$'))
        if bufwinnr(l) == -1
          exec 'sbuffer ' . l
        endif
      endfor
    endif
  endif
endfunction

autocmd VimLeave * call SaveSession()
autocmd VimEnter * nested call RestoreSession()
