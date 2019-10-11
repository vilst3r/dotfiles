filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

:set relativenumber
:set ruler
:set showcmd
:set cursorline
:set background=dark
:set hlsearch
:syntax enable
:colorscheme gruvbox

" Configure cursor line to suit Pro profile theme of terminal
hi cursorline cterm=underline ctermbg=black

" turn off search highlight
let mapleader=","       " leader is comma
nnoremap <leader><space> :nohlsearch<CR>

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Allow backward compatibility for latest version of vim in insert mode
set backspace=indent,eol,start
