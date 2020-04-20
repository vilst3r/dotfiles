""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Optional - Plugin Management (configurations are near the EOF)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Automatic installation with autoload directory
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'morhetz/gruvbox'
Plug 'ludovicchabant/vim-gutentags'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
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
set cursorline
set ruler " Show line & column no. seperated by a comma
set vb t_vb= " Disable visual & audio bell
set backspace=indent,eol,start " Allow backspace modification for the following

" Auto-Fill-Mode
set colorcolumn=80
set textwidth=80
set wrap

" Searching
set path+=** " Recursive search from current directory
set wildmenu " Show all matching files when we tab complete
set incsearch "Incremental search
set hlsearch
set ignorecase "Ignore case when searching
set smartcase

" GUI
syntax enable
set background=dark
silent! colorscheme gruvbox
" Better visual cursor line for iTerm
hi cursorline cterm=underline ctermbg=black

" General Keymappings
let mapleader="," " For event based mappings below
" Get buffer x (number or substring candidate)
nnoremap <C-x>b :ls<CR>:b<Space>
" Move vertically within a single line that's soft wrapped
nnoremap j gj
nnoremap k gk
" Use Emacs bindings for command line mode
cmap <C-p> <Up>
cmap <C-n> <Down>
cmap <C-b> <Left>
cmap <C-f> <Right>
cmap <C-a> <Home>
cmap <C-e> <End>
cnoremap <C-d> <Del>
cnoremap <C-h> <BS>
cnoremap <C-g> <C-c>
function s:killLine()
    if getcmdpos() == 1
        return ''
    else
        return getcmdline()[:getcmdpos() - 2]
    endif
endfunction
cnoremap <C-k> <C-\>e <SID>killLine()<CR>
" Turn off search highlighting & clear query at bottom of window
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Event-based Keymappings
augroup main
    " Clear autocommands of this group when opening new vim buffer
    autocmd!
    autocmd FileType help noremap <buffer> q :q<CR>

    " Build cpp buffer
    autocmd filetype cpp nnoremap <leader>c :w <bar>
                                    \!g++ -std=c++14 -O2 -Wall % -o %:r<CR>
    " Executes compiled file of cpp buffer if it exists
    autocmd filetype cpp nnoremap <leader>r :w <bar> :!./%:r<CR>
    autocmd filetype cpp nnoremap <leader>m :w <bar> :!make<CR>
    autocmd filetype python nnoremap <leader>r :w <bar> !python3 %<CR>
augroup end

" Tags
set tags=./tags;,tags;
nnoremap <C-]> g<C-]>
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => FZF (plugin config)
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Add kill-line to fzh windows
let $FZF_DEFAULT_OPTS='--bind ctrl-k:kill-line'

command GitProjectFiles call fzf#run({
\  'source': 'git ls-files',
\  'sink':   'e',
\  'down':   '30%'})

function! s:bufferList()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufferOpen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:ag_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

command! -nargs=* Ag call fzf#run({
\ 'source':  printf('ag --nogroup --column --color "%s"',
\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
\ 'sink*':    function('<sid>ag_handler'),
\ 'options': '--ansi --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
\            '--multi --bind=ctrl-a:select-all,ctrl-d:deselect-all '.
\            '--color hl:68,hl+:110',
\ 'down':    '50%'
\ })

command AutoCompleteBufferList call fzf#run({
\   'source':  reverse(<sid>bufferList()),
\   'sink':    function('<SID>bufferOpen'),
\   'options': '+m',
\   'down':    len(<sid>bufferList()) + 2
\ })

nnoremap <silent> <C-c>pf :GitProjectFiles<CR>
nnoremap <silent> <C-x>b :AutoCompleteBufferList<CR>
nnoremap <silent> <C-x>k :bd<CR>
nnoremap <silent> <C-c>ps :Ag<CR>


