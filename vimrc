if &compatible
  set nocompatible
endif

call plug#begin('~/.vim/plugged')

" general editing
Plug 'ervandew/supertab' "tab completion
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "fuzzy finder
Plug 'junegunn/fzf.vim' "finder vim bindings
Plug 'kana/vim-textobj-user' "user text objects
Plug 'nanotech/jellybeans.vim' "colors
Plug 'scrooloose/syntastic' "syntax
Plug 'tpope/vim-commentary' "commenting with gc
Plug 'tpope/vim-endwise' "end blocks
Plug 'tpope/vim-fugitive'  "git
Plug 'tpope/vim-repeat'  "repeat custom commands
Plug 'tpope/vim-unimpaired' "bracket mappings
Plug 'tpope/vim-vinegar' "netrw more nicely

" gists
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'

" ruby
Plug 'nelstrom/vim-textobj-rubyblock', { 'for': 'ruby' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }
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
set nowrap
set lazyredraw

runtime macros/matchit.vim

au BufRead,BufNewFile *.md setf markdown
au BufRead,BufNewFile *.rake setf ruby
au BufRead,BufNewFile *.rabl setf ruby
au BufRead,BufNewFile *.jbuilder setf ruby

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
let mapleader="\<space>"
let localmapleader="\<space>"

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
nmap <leader>pi :source ~/.vimrc<cr>:PlugInstall<cr>

" fzf shortcuts
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <Leader>h :History<cr>

" open netrw
nnoremap <silent> <Leader>v :Vexplore<cr>
nnoremap <silent> <Leader>s :Explore<cr>

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
