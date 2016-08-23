if &compatible
  set nocompatible
endif

call plug#begin('~/.vim/plugged')

" general editing
Plug 'ervandew/supertab' "tab completion
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "fuzzy finder
Plug 'junegunn/fzf.vim' "finder vim bindings
Plug 'nanotech/jellybeans.vim' "colors
Plug 'scrooloose/syntastic' "syntax
Plug 'tpope/vim-commentary' "commenting with gc
Plug 'tpope/vim-endwise' "end blocks
Plug 'tpope/vim-fugitive'  "git
Plug 'tpope/vim-repeat'  "repeat custom commands
Plug 'tpope/vim-unimpaired' "bracket mappings
Plug 'tpope/vim-vinegar' "netrw more nicely
Plug 'Shougo/neomru.vim' "fzf mru search

" gists
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'

" ruby
Plug 'tpope/vim-rails'
Plug 'tpope/vim-bundler'

" markdown
Plug 'junegunn/vim-xmark', { 'do': 'make' }

call plug#end()

" Display options
colorscheme jellybeans

filetype plugin indent on
syntax on
set t_Co=256
set number
set lazyredraw

au BufRead,BufNewFile *.md setf markdown

set laststatus=2

" Misc
set directory=/tmp "sets the swap (.swp) file directory
set backupdir=/tmp

" Search settings
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch

set wildmenu
set wildmode=list:longest,full


"""""""""""""""""""""""""
" Keybindings
"""""""""""""""""""""""""
let mapleader=" "
let localmapleader=" "

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

set backspace=eol,start,indent  " Allow backspacing over indent, eol, & start
set smarttab                    " Make <tab> and <backspace> smarter
set expandtab
set tabstop=2
set shiftwidth=2
set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.

noremap k gk
noremap j gj

nnoremap <leader><space> :Files<cr>
nnoremap <silent> <Leader>m :call fzf#run({
      \   'source': 'sed "1d" $HOME/.cache/neomru/file',
      \   'sink': 'e '
      \ })<CR>

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
