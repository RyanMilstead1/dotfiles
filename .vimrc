"""""""""""""""""""""""""""
Plugins
"""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

Plug 'tyrannicaltoucan/vim-quantum'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'jiangmiao/auto-pairs'
Plug 'Townk/vim-autoclose'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'Yggdroot/indentLine'
Plug 'vim-ruby/vim-ruby'
Plug 'ervandew/supertab'
Plug 'posva/vim-vue'
Plug 'severin-lemaignan/vim-minimap'
Plug 'djoshea/vim-autoread'
Plug 'slim-template/vim-slim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'Chiel92/vim-autoformat'
Plug '907th/vim-auto-save'
Plug 'machakann/vim-highlightedyank'
Plug 'ntpeters/vim-better-whitespace'
Plug 'vim-syntastic/syntastic'

call plug#end()
"""""""""""""""""""""""""""

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Properly disable sound on errors on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" Do not make vim compatible with vi.
set nocompatible

" Do not create .swp files
set noswapfile

" Number the lines.
set number

" Show auto complete menus.
set wildmenu

" Make wildmenu behave like bash completion. Finding commands are so easy now.
set wildmode=list:longest

" Enable mouse pointing
set mouse=a

" ALWAYS spaces
set expandtab

" Fix backspace behavior
set backspace=indent,eol,start

" Use system clipboard
set clipboard=unnamed

" Keep Undo history on buffer change
set hidden
" Reload files after change on Disk
"set autoread
"au CursorHold * checktime

" Turn on syntax hightlighting.
set syntax=on
set nowrap
set tabstop=2
set shiftwidth=2
set nocindent

" Speed optimization
set ttyfast
set lazyredraw

" Theme
set background=dark
if exists('+termguicolors')
set termguicolors
endif
colorscheme quantum
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14

" Airline
set laststatus=2
let g:airline#extensions#tabline#enabled=1
let g:airline_theme='bubblegum'
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1

" Indent Guides
let g:indentLine_enabled=1
let g:indentLine_color_term=235
let g:indentLine_char='┆'

" Syntastic
if exists('SyntasticStatuslineFlag')
  set statusline+=%#warningmsg#
  set statusline+=%{SyntasticStatuslineFlag()}
  set statusline+=%*
endif

let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0

let g:auto_save = 1

let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

" Autoformatter python location
let g:python3_host_prog='/usr/local/bin/python3'

" Start Minimap
" autocmd VimEnter * Minimap

" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if v:version < 700 || exists('loaded_bclose') || &cp
finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
let bclose_multiple = 1
endif

" Chain vimgrep and copen
augroup qf
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    cwindow
    autocmd VimEnter        *     cwindow
augroup END

" Change cursor appearance depending on the current mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

" This is handled by lightline
set noshowmode

" Show file path in lightline
" https://github.com/itchyny/lightline.vim/issues/87#issuecomment-119130738
let g:lightline = {
  \ 'colorscheme': 'darcula',
  \ 'active': {
  \   'right': [['lineinfo'], ['fileformat', 'filetype']]
  \ },
  \ 'component_function': {
  \   'filename': 'LightLineFilename'
  \ },
  \ 'component': {
  \   'lineinfo': "[%l:%-v] [%{printf('%03d/%03d',line('.'),line('$'))}]",
  \ }
  \ }
function! LightLineFilename()
  return expand('%')
endfunction

""""""""""""""""""""""""""
" Custom bindings
""""""""""""""""""""""""""
let mapleader = ","

" Set 7 lines to the cursor - when moving vertically using j/k
set so=7

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" Browse airline tabs
:nnoremap <C-p> :bnext<CR>
:nnoremap <C-o> :bprevious<CR>

" Map Control S for save
noremap <silent> <C-S> :update<CR>
vnoremap <silent> <C-S> <C-C>:update<CR>
inoremap <silent> <C-S>  <C-O>:update<CR>

" Comment block
vnoremap <silent> <C-k> :Commentary<cr>

" Close current buffer
noremap <silent> <C-q> :Bclose!<CR>

" Select all
map <C-a> <esc>ggVG<CR>

" Find files with fzf
nmap <leader>p :Files!<CR>

" Unmap arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

nmap // :BLines!<CR>
nmap ?? :Rg!<CR>

" remap ESC to exit terminal mode (breaks fzf popup)
tnoremap <Esc> <C-\><C-n>

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

