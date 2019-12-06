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
Plug 'tpope/vim-surround'  "surround custom commands
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

" go
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'buoto/gotests-vim', { 'for': 'go' }

" haskell
Plug 'dag/vim2hs', { 'for': 'haskell' }

call plug#end()

" Display options
colorscheme jellybeans

filetype plugin indent on
syntax on
set t_Co=256
set number
set nowrap
set linebreak
set lazyredraw

runtime macros/matchit.vim

set backspace=eol,start,indent  " Allow backspacing over indent, eol, & start
set smarttab                    " Make <tab> and <backspace> smarter
set expandtab
set tabstop=2
set shiftwidth=2
set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.

au BufRead,BufNewFile *.md setf markdown
au BufRead,BufNewFile *.rake,*.rabl,*.jbuilder setf ruby

au FileType python setlocal tabstop=4|setlocal shiftwidth=4
au FileType go setlocal noexpandtab|setlocal tabstop=8|setlocal shiftwidth=8
au FileType proto setlocal smartindent

set laststatus=2

" Misc
set noswapfile
set nobackup

" Search settings
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch

set wildmenu
set wildmode=list:longest,full

" Show me where 80 chars is
set colorcolumn=80
hi ColorColumn ctermbg=235 guibg=#2c2d27

"""""""""""""""""""""""""
" Keybindings
"""""""""""""""""""""""""
let mapleader="\<space>"
let localmapleader="\<space>"

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <S-l> gt
nnoremap <S-h> gT

nnoremap <leader>b <C-^>

noremap k gk
noremap j gj
nnoremap <leader>pi :source ~/.vimrc<cr>:PlugInstall<cr>

" json
nnoremap <silent> <leader>jj :%!python -m json.tool<cr>

" fzf shortcuts
let g:fzf_history_dir = '~/.local/share/fzf-history'
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <Leader>h :History<cr>
nnoremap <silent> <Leader>t :Tags<cr>
nnoremap <Leader>a :Ag 

" open netrw
nnoremap <silent> <Leader>v :Vexplore<cr>
nnoremap <silent> <Leader>s :Sexplore<cr>

nnoremap <silent> <leader>; :nohl<cr>
vnoremap s :!sort<CR>
nnoremap <silent> <leader>w :set wrap!<cr>
noremap Q @q

function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
nnoremap <Leader>n :call RenameFile()<cr>

if filereadable(expand("~/.custom.vim"))
  source ~/.custom.vim
endif

"go highlighting
let g:go_highlight_functions=1
let g:go_highlight_types=1

"go key bindings
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
autocmd FileType go nnoremap <leader>got :GoTests<cr>
