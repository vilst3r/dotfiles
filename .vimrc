""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
set number
set relativenumber
set showcmd
set cursorline
set ruler " Show line & column no. seperated by a comma
set vb t_vb= " Disable visual & audio bell
set backspace=indent,eol,start " Allow backspace modification for the following

" Auto-Fill-Mode
set colorcolumn=80
set textwidth=80
set wrap

" Searching
set incsearch "Incremental search"
set hlsearch
set ignorecase "Ignore case when searching
set smartcase

" GUI
syntax enable
set background=dark
colorscheme gruvbox
" Better visual cursor line for iTerm
hi cursorline cterm=underline ctermbg=black

" General Keymappings
let mapleader="," " For event based mappings below
" Get buffer x (number or substring candidate)
nnoremap gb :ls<CR>:b<Space>
" Move vertically within a single line that's soft wrapped
nnoremap j gj
nnoremap k gk
" Turn off search highlighting & clear query at bottom of window
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Event-based Keymappings
autocmd FileType help noremap <buffer> q :q<CR>
" Build cpp buffer
autocmd filetype cpp nnoremap <leader>c 
                            \:w <bar> !g++ -std=c++14 -O2 -Wall % -o %:r<CR>
" Executes compiled file of cpp buffer if it exists
autocmd filetype cpp nnoremap <leader>r :w <bar> :!./%:r<CR>
autocmd filetype cpp nnoremap <leader>m :w <bar> :!make<CR>
autocmd filetype python nnoremap <leader>r :w <bar> !python3 %<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on
set tabstop=2     " Show existing tabs with 4 spaces
set shiftwidth=4  " Indenting '>', use 4 spaces of the column width
set softtabstop=4 " Number of columns for a TAB
set expandtab     " Convert tabs to spaces
autocmd fileType cpp setlocal shiftwidth=2 softtabstop=2
autocmd fileType javascript setlocal shiftwidth=2 softtabstop=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General macros
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let @c='ggVG"+y' "Save entire buffer to system clipboard
let @l='0v$h"+y' "Save entire line to system clipboard

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Powerline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Powerline
let g:repository_root = trim(system('python3 -m site --user-site'))
execute 'set rtp+=' . g:repository_root . '/powerline/bindings/vim'
set laststatus=2
set t_Co=256

