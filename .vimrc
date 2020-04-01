"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
set rnu number
set ruler
set showcmd
set cursorline
set colorcolumn=80

" Auto-Fill-Mode
set textwidth=80
set wrap

" Bell
set vb "no visual bell"
set t_vb= "no visual bell"

" Searching
set hlsearch
set ignorecase "Ignore case when searching
set smartcase
set incsearch "Incremental search"

" GUI
set background=dark
syntax enable
colorscheme gruvbox
" Configure cursor line to suit Pro profile theme of terminal
hi cursorline cterm=underline ctermbg=black

" Keymappings
let mapleader=","       " leader is comma
nnoremap <leader><space> :nohlsearch<CR>    "turn off search highlight

" Move vertically within a single line that's wrapped
nnoremap j gj
nnoremap k gk

" Allow backward compatibility for latest version of vim in insert mode
set backspace=indent,eol,start

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on
" Settings below will override if file type not supported
set tabstop=4 " show existing tabs with 4 spaces
set shiftwidth=4 " indenting '>', use 4 spaces width
set expandtab " Convert tabs to spaces

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General macros
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Save entire buffer to system clipboard (assuming you have osx clipboard enabled)
let @c='ggVG"+y'
" Save entire line to system clipboard
let @l='0v$h"+y'
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => C++ Configuration
" See "https://linux.die.net/man/1/g++" for info on compiler options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Build cpp buffer
autocmd filetype cpp nnoremap + :w <bar> !g++ -std=c++14 -O2 -Wall % -o %:r<CR>
" Executes compiled file of cpp buffer if it exists
autocmd filetype cpp nnoremap _ :w <bar> :!./%:r<CR>
autocmd FileType cpp setlocal shiftwidth=2 softtabstop=2 expandtab

