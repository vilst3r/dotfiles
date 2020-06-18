""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin Management
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatic installation with autoload directory
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'jiangmiao/auto-pairs'
call plug#end()

" Automatic installation of missing plugins
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
set number
set relativenumber
set showcmd
set ruler " Show line & column no. seperated by a comma
set vb t_vb= " Disable visual & audio bell
set backspace=indent,eol,start " Allow backspace modification for the following

" Auto-Fill-Mode
set colorcolumn=80
set textwidth=80
set wrap

" Searching
set wildmenu " Show all matching files when we tab complete
set incsearch "Incremental search
set hlsearch
set ignorecase "Ignore case when searching
set smartcase

" Turn backup files off
set nobackup
set nowb
set noswapfile

" GUI
syntax on
set background=dark
silent! colorscheme gruvbox

" General Keymappings
let mapleader=","
" Move vertically within a single line that's soft wrapped
nnoremap j gj
nnoremap k gk
" Turn off search highlighting & clear query at bottom of window
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Event-based Keymappings
augroup main
    " Clear autocommands of this group when opening new vim buffer
    autocmd!
    autocmd FileType help noremap <buffer> q :q<CR>

    autocmd filetype cpp nnoremap <leader>b :w <bar> :!clear &&
                                    \g++ -std=c++17 -O2 -Wall % -o %:r<CR>
    autocmd filetype cpp nnoremap <leader>r :w <bar> :!clear && ./%:r<CR>
    autocmd filetype cpp nnoremap <leader>m :w <bar> :!clear && make<CR>
    autocmd filetype python nnoremap <leader>r :w <bar> !clear && python3 %<CR>
augroup end

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
filetype plugin indent on
set tabstop=2     " Show existing tabs with 4 spaces
set shiftwidth=4  " Indenting '>', use 4 spaces of the column width
set softtabstop=4 " Number of columns for a TAB
set expandtab     " Convert tabs to spaces
autocmd fileType cpp setlocal shiftwidth=2 softtabstop=2

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General macros
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let @c='ggVG"+y' "Save entire buffer to system clipboard
let @l='0v$h"+y' "Save entire line to system clipboard

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Powerline
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:repository_root = trim(system('python3 -m site --user-site'))
execute 'set rtp+=' . g:repository_root . '/powerline/bindings/vim'
set laststatus=2
set t_Co=256
