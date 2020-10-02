if &compatible
  set nocompatible
endif

call plug#begin('~/.vim/plugged')

" general editing
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "fuzzy finder
Plug 'junegunn/fzf.vim' "finder vim bindings
Plug 'kana/vim-textobj-user' "user text objects
Plug 'nanotech/jellybeans.vim' "colors
Plug 'scrooloose/syntastic' "syntax
Plug 'tpope/vim-abolish' "word variants
Plug 'tpope/vim-commentary' "commenting with gc
Plug 'tpope/vim-endwise' "end blocks
Plug 'tpope/vim-fugitive'  "git
Plug 'tpope/vim-repeat'  "repeat custom commands
Plug 'tpope/vim-surround'  "surround custom commands
Plug 'tpope/vim-unimpaired' "bracket mappings
Plug 'tpope/vim-vinegar' "netrw more nicely
Plug 'vim-airline/vim-airline'

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

" c++
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': 'cpp' }

Plug 'mhinz/vim-signify'

" LSP client
Plug 'neoclide/coc.nvim', {'branch': 'release'} " note node dep

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
autocmd! BufWritePost vimrc source $MYVIMRC
augroup myvimrchooks
  " clears myvimrchooks group, to not repeat the autocmd below
  au!
  autocmd BufWritePost vimrc source $MYVIMRC
augroup END

set laststatus=2

" Misc
set noswapfile
set nobackup
set hidden " TextEdit might fail if hidden is not set.
set nowritebackup
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Search settings
set ignorecase
set smartcase
set hlsearch
set incsearch
set showmatch

set wildmenu
set wildmode=list:longest,full

" Show me where 80 chars is
hi ColorColumn ctermbg=235 guibg=#2c2d27
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set colorcolumn=80
  autocmd WinLeave * set colorcolumn=0
augroup END

" Cursorline {{{
" Only show cursorline in the current window and in normal mode.
augroup cline
    au!
    au WinLeave * set nocursorline
    au WinEnter * set cursorline
    au InsertEnter * set nocursorline
    au InsertLeave * set cursorline
augroup END
" }}}


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

nnoremap <leader>pi :PlugInstall<cr>

nnoremap <leader>ev :tabe $MYVIMRC<cr>

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

" Allow mapping from LSP instead.
let g:go_def_mapping_enabled = 0

" -------------------------------------------------------------------------------------------------
" coc.nvim default settings
" -------------------------------------------------------------------------------------------------

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  " inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Ignoring for now
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

let airline#extensions#coc#enabled=1

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> ,a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> ,e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> ,c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> ,o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> ,s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> ,j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> ,k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
