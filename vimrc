if &compatible
  set nocompatible
endif

call plug#begin('~/.vim/plugged')

" general editing
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" colors
Plug 'nanotech/jellybeans.vim'

" gists
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'

" ruby
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'
Plug 'scrooloose/syntastic'

call plug#end()

colorscheme jellybeans

" Display options
filetype plugin indent on
syntax on
set t_Co=256

" Misc
set directory=/tmp "sets the swap (.swp) file directory

" Search settings
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch

"""""""""""""""""""""""""
" Keybindings
"""""""""""""""""""""""""
let mapleader="<space>"
let localmapleader="<space>"

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set backspace=eol,start,indent  " Allow backspacing over indent, eol, & start
set smarttab                    " Make <tab> and <backspace> smarter
set expandtab
set tabstop=2
set shiftwidth=2

noremap k gk
noremap j gj

vmap s :!sort<CR>
map Q @q

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <Leader>n :call RenameFile()<cr>

"Matchit macro for ruby block text objects
runtime macros/matchit.vim

if !exists("*UpdatePlugins")
  function! UpdatePlugins()
    source ~/.vimrc
    PlugInstall
  endfunction
endif
