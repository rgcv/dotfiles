"        _
" __   _(_)_ __ ___
" \ \ / / | '_ ` _ \
"  \ V /| | | | | | |
"   \_/ |_|_| |_| |_|
"

set encoding=utf-8
filetype plugin indent on
scriptencoding utf-8

"" plugins
let s:install_plugins=0
if empty(glob('~/.vim/plugged'))
  silent !curl
        \ --create-dirs
        \ --fail
        \ --location
        \ --output ~/.vim/autoload/plug.vim
        \ https://raw.github.com/junegunn/vim-plug/master/plug.vim
  let s:install_plugins=1
endif

call plug#begin('~/.vim/plugged')
Plug 'airblade/vim-gitgutter'
Plug 'andreshazard/vim-freemarker'
Plug 'ararslan/license-to-vim'
Plug 'chr4/nginx.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'cocopon/lightline-hybrid.vim'
Plug 'felixhummel/setcolors.vim'
Plug 'itchyny/lightline.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'kana/vim-textobj-user'
\ | Plug 'kana/vim-textobj-entire'
Plug 'lepture/vim-jinja'
Plug 'mattn/emmet-vim'
Plug 'mike-hearn/base16-vim-lightline'
Plug 'Potatoesmaster/i3-vim-syntax'
Plug 'pangloss/vim-javascript'
Plug 'pearofducks/ansible-vim'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'roxma/vim-paste-easy'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
\ | Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-scripts/argtextobj.vim'
call plug#end()

if s:install_plugins == 1
  PlugInstall
endif

" options
let mapleader=','
let mapleaderlocal=','

set autoindent " Copy indent from current line when starting new one
set autoread " Read file if changes outside vim were detected
set autowrite " Auto write in certain circumstances
set background=dark " Use colors for a dark background
set backspace=indent,eol,start " Allow backspacing over a few things
set belloff=all " Bell off for every event
set clipboard=unnamedplus " Sync w/ system clipboard
set colorcolumn=+1,120 " Just after tetwidth, hard cut at 120
set completeopt=menu,menuone,noselect
set conceallevel=3 " Fully conceal special markup
set confirm " Confirm changes before exiting dirty buffer
set cscopeverbose
set cursorline " Highlight the current line
set display=lastline
set expandtab " Use spaces instead of tabs
set formatoptions=tcroqnlj " default: tcqj
if exists('+fsync')
  set nofsync
endif
set history=1000 " History size
set hlsearch " For a previous search pattern, highlight all matches
set ignorecase " Ignore case in search patterns
set incsearch " Show search pattern match as one types
if exists('+langremap')
  set nolangremap
endif
set laststatus=2 " only show a status line if >1 window is open
set list
set listchars="tab:→ ,trail:-,space:·,nbsp:+"
set mouse=a " Enable mouse mode
set nowrap " Disable line wrapping
set number " Show line numbers
set path-=. path^=.,**
set pumheight=10 " Max. number of items to show in the popup menu
set ruler " Show the line and column number of the cursor position
set scrolloff=4 " Lines of context
set sessionoptions-=options
set shiftround " Round indents to multiples of 'shiftwidth'
set shiftwidth=2 " Size of an indent
set showcmd " Show (partial) command in the last line of the screen
set sidescroll=1 " Minimal number of cols to scroll horizontally
set sidescrolloff=8 " Columns of context
if exists('+signcolumn')
  set signcolumn=number " Display signs in the 'number' column, otherwise auto
endif
set smartcase " Overrides 'ignorecase' with uppercase
set smartindent " Insert indent automatically
set smarttab
set splitbelow " Split new windows below current
set splitright " Split new windows right of current
set tabpagemax=50
set tags="./tags;,tags" " Filenames for :tag
if has('termguicolors')
  set termguicolors
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
endif
set timeout timeoutlen=1000 " Time in ms for a mapped sequence to complete
set ttimeout ttimeoutlen=50 " Separate timeout for key codes
set ttyfast " Indicates a fast tty connection
set undofile
set undolevels=1000
set updatetime=500 " Save swap file sooner
set viminfo+="!"
set wildmenu " Enhanced command-line completion
set wildoptions=tagfile

if !has('gui_running')
  set t_Co=256
endif

let s:colorscheme='hybrid'

" mappings
let &t_TI="\<Esc>[>4;2m"
let &t_TE="\<Esc>[>4;m"
" better up/down
if !has('ide')
  nnoremap <silent> <expr> j v:count == 0 ? 'gj' : 'j'
  nnoremap <silent> <expr> k v:count == 0 ? 'gk' : 'k'
endif

" Move to window bypassing <C-w>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>

" Move lines
nnoremap <A-j> <Cmd>m .+1<CR>==
nnoremap <A-k> <Cmd>m .-2<CR>==
inoremap <A-j> <Esc><Cmd>m .+1<CR>==gi
inoremap <A-k> <Esc><Cmd>m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
if !has('ide')
  nnoremap <expr> n 'Nn'[v:searchforward]
  xnoremap <expr> n 'Nn'[v:searchforward]
  onoremap <expr> n 'Nn'[v:searchforward]
  nnoremap <expr> N 'nN'[v:searchforward]
  xnoremap <expr> N 'nN'[v:searchforward]
  onoremap <expr> N 'nN'[v:searchforward]
endif

" better indenting
vnoremap < <gv
vnoremap > >gv

" auto cd to current file's working dir
nnoremap <Leader>cd :silent call AutoCD()<CR>
function! AutoCD()
  if expand('%:p:h') !~# '^/tmp'
    return
  endif
  lcd %:p:h
endfunction
" run current file
nnoremap <Leader>x :!%:h/%:t<CR>

" plugins
" ctrlp
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_status_func = {
      \ 'main': 'CtrlPStatusFuncMain',
      \ 'prog': 'CtrlPStatusFuncProg',
      \ }
let g:ctrlp_working_path_mode = 'ra'

function! CtrlPStatusFuncMain(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFuncProg(str)
  return lightline#statusline(0)
endfunction
" ftplugin
let g:tex_flavor = 'latex'
" julia-vim
let g:latex_to_unicode_auto = 1
" lightline.vim
let g:lightline = {
      \ 'colorscheme': s:colorscheme,
      \ 'active': {
      \   'left': [
      \     ['mode', 'paste', 'spell'],
      \     ['fugitive', 'filename', 'readonly'],
      \     ['ctrlpmark'],
      \   ],
      \   'right': [
      \     ['percent', 'lineinfo'],
      \     ['fileformat', 'fileencoding', 'filetype'],
      \   ],
      \ },
      \ 'component': {
      \   'fileformat':    "%{winwidth(0) > 70 ? &fileformat : ''}",
      \   'fileencoding':  "%{winwidth(0) > 70 ? &fileencoding : ''}",
      \   'readonly':      "%{&readonly && &filetype !=# 'help' ? 'RO' : ''}",
      \ },
      \ 'component_function': {
      \   'ctrlpmark':    'CtrlPMark',
      \   'filename':     'LightlineFilename',
      \   'filetype':     'LightlineFiletype',
      \   'fugitive':     'LightlineFugitive',
      \   'mode':         'LightlineMode',
      \ },
      \ 'subseparator': { 'left': '', 'right': '' },
      \}

function! CtrlPMark()
  if &filetype ==# 'ctrlp' && has_key(g:lightline, 'ctrlp_item')
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev
          \ , g:lightline.ctrlp_item, g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

function! LightlineFilename()
  if &filetype ==# 'help' | return expand('%:t') | endif
  let filename = substitute(expand('%:.:p'), expand('$HOME'), '~', '')
  return
        \ &filetype ==# 'ctrlp' && has_key(g:lightline, 'ctrlp_item') ?
          \ g:lightline.ctrlp_item :
        \ &filetype ==# 'vim-plug' ? '' :
        \ ''
          \ . (&modified ? '*' : '')
          \ . (filename !=# '' ? filename : '[no name]')
endfunction

function! LightlineFiletype()
  return winwidth(0) <= 70 ? '' :
        \ &filetype =~# 'ctrlp\|vim-plug' ? '' :
        \ &filetype !=# '' ? &filetype :
        \ 'no ft'
endfunction

function! LightlineFugitive()
  return exists('*fugitive#head') ? fugitive#head() : ''
endfunction

function! LightlineMode()
  return &filetype =~# 'ctrlp\|help\|vim-plug' ? toupper(&filetype) :
       \ winwidth(0) > 60 ? lightline#mode() :
       \ ''
endfunction
" vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
" vim-plug
command! PU PlugUpdate | PlugUpgrade

" autocmds
augroup init#resize_splits
  autocmd!
  autocmd VimResized tabdo wincmd =
augroup END

augroup init#close_with_q
  autocmd!
  autocmd FileType help,lspinfo,man,notify,qf,startuptime
        \ setlocal nobuflisted | nmap <silent> <buffer> q <Cmd>close<CR>
augroup END

augroup init#spelling
  autocmd!
  autocmd FileType gitcommit,markdown,tex setlocal spell
augroup END

augroup init#textwidth
  autocmd!
  autocmd FileType * if &textwidth == 0 | setlocal textwidth=80 | endif
augroup END

augroup init#configs
  autocmd!
  autocmd BufWritePost $MYVIMRC nested source %
augroup END

execute 'colorscheme' s:colorscheme
highlight Normal guibg=NONE ctermbg=NONE
