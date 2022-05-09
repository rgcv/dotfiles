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
if empty(glob('~/.vim/plugged'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.github.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')
Plug 'AndrewRadev/tagalong.vim'
Plug 'airblade/vim-gitgutter'
Plug 'andreshazard/vim-freemarker'
Plug 'ararslan/license-to-vim'
Plug 'chr4/nginx.vim'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'itchyny/lightline.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'junegunn/vim-slash'
Plug 'kana/vim-textobj-user' |
\ Plug 'kana/vim-textobj-entire'
Plug 'lepture/vim-jinja'
Plug 'mattn/emmet-vim'
Plug 'mike-hearn/base16-vim-lightline'
Plug 'neomake/neomake' |
\ Plug 'sinetoami/lightline-neomake'
Plug 'Potatoesmaster/i3-vim-syntax'
Plug 'pangloss/vim-javascript'
Plug 'pearofducks/ansible-vim'
Plug 'roxma/vim-paste-easy'
Plug 'Shougo/echodoc'
Plug 'Shougo/neosnippet.vim' |
\ Plug 'Shougo/neosnippet-snippets'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive' |
\ Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-scripts/argtextobj.vim'
Plug 'wannesm/wmgraphviz.vim'
call plug#end()

" options
" nvim defaults
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
" set belloff=all
set complete-=i
set cscopeverbose
set display="lastline,msgsep"
set fillchars="vert:│,fold:·"
set formatoptions=tcqj
set history=10000
set hlsearch
set incsearch
"" set langnoremap
set laststatus=2
set listchars="tab:> ,trail:-,nbsp:+"
set ruler
set sessionoptions-=options
set showcmd
set sidescroll=1
set smarttab
set tabpagemax=50
set tags="./tags;,tags"
set ttimeoutlen=50
set ttyfast
set viminfo+="!"
set wildmenu
set wildoptions="pum,tagfile"

if exists('+fsync')
  set nofsync
endif
if exists('+langremap')
  set nolangremap
endif
" vint: -ProhibitSetNoCompatible
set nocompatible
" vint: +ProhibitSetNoCompatible

set clipboard=unnamed,unnamedplus " yank to X + primary clipboards
set colorcolumn=+1
set expandtab " I like spaces, don't @ me
set path+=**
set mouse=a " enable mouse support if we have it
set number relativenumber
set shiftwidth=2
set scrolloff=8 sidescrolloff=8
if exists('+signcolumn')
  set signcolumn=yes " always show gutter
endif
set smartindent
set splitbelow splitright
if has('termguicolors')
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

if !has('gui_running')
  set t_Co=256
endif

colorscheme base16-material-darker

set nowrap

" mappings
" \ (backward slash) is a bit far, use `,` (comma) as leader instead
let mapleader = ','
" auto cd to current file's working dir
nnoremap <leader>cd :call AutoCD()<CR>:pwd<CR>
function! AutoCD()
  if expand('%:p:h') !~# '^/tmp' | lcd %:p:h | endif
endfunction
" movement between windows
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
" run current file
nnoremap <leader>x :!%:h/%:t<CR>

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
" echodoc
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'floating'
" ftplugin
let g:tex_flavor = 'latex'
" julia-vim
let g:latex_to_unicode_auto = 1
" lightline.vim
let g:lightline = {
      \ 'colorscheme': exists('+termguicolors') ? 'base16_material_darker' : 'wombat',
      \ 'active': {
      \   'left': [
      \     ['mode', 'paste', 'spell'],
      \     ['fugitive', 'filename', 'readonly'],
      \     ['ctrlpmark'],
      \   ],
      \   'right': [
      \     map(['errors', 'warnings', 'infos', 'ok'], '"neomake_".v:val'),
      \     ['percent', 'lineinfo'],
      \     ['fileformat', 'fileencoding', 'filetype'],
      \   ],
      \ },
      \ 'component': {
      \   'fileformat':    '%{winwidth(0) > 70 ? &fileformat : ""}',
      \   'fileencoding':  '%{winwidth(0) > 70 ? &fileencoding : ""}',
      \   'readonly':      '%{&readonly && &filetype !=# "help" ? "RO" : ""}',
      \ },
      \ 'component_expand': {
      \   'neomake_errors':   'lightline#neomake#errors',
      \   'neomake_ok':       'lightline#neomake#ok',
      \   'neomake_warnings': 'lightline#neomake#warnings',
      \ },
      \ 'component_function': {
      \   'ctrlpmark':    'CtrlPMark',
      \   'filename':     'LightlineFilename',
      \   'filetype':     'LightlineFiletype',
      \   'fugitive':     'LightlineFugitive',
      \   'mode':         'LightlineMode',
      \ },
      \ 'component_type': {
      \   'neomake_errors':   'error',
      \   'neomake_infos':    'info',
      \   'neomake_warnings': 'warning',
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
          \ . (filename !=# '' ? filename : '[untitled]')
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
" lightline-neomake
let g:lightline#neomake#prefix_ok = '✓'
let g:lightline#neomake#prefix_errors = '✗ '
let g:lightline#neomake#prefix_infos = '¡ '
let g:lightline#neomake#prefix_warnings = '!! '
" neomake
silent! call neomake#configure#automake('nrwi', 750)
" neosnippet
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
if has('conceal')
  set conceallevel=2
endif
" vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
" vim-plug
command! PU PlugUpdate | PlugUpgrade

" autocmds
augroup init#configs
  autocmd!
  autocmd BufWritePost $MYVIMRC nested source %

  autocmd BufWritePost ~/.config/dunst/dunstrc
        \ silent !systemctl --user restart dunst
  autocmd BufWritePost ~/.config/mako/config silent !makoctl reload
  autocmd BufWritePost ~/.config/termite/config  silent !pkill -USR1 termite
  autocmd BufWritePost ~/.config/i3blocks/config silent !i3-msg restart
augroup END

augroup init#misc
  autocmd!
  " set tw and colorcolumn upon enter or filetype
  autocmd FileType * call SetTextWidth()
  " trim trailing whitespace
  autocmd BufWritePre    * call StripTrailingWhitespace()
  autocmd FileAppendPre  * call StripTrailingWhitespace()
  autocmd FileWritePre   * call StripTrailingWhitespace()
  autocmd FilterWritePre * call StripTrailingWhitespace()
augroup END

function! SetTextWidth()
  if &textwidth == 0 | setlocal textwidth=80 | endif
endfunction

function! StripTrailingWhitespace()
  let l = line('.')
  let c = col('.')
  " vint: -ProhibitCommandRelyOnUser -ProhibitCommandWithUnintendedSideEffect
  %s/\s\+$//e
  " vint: +ProhibitCommandRelyOnUser +ProhibitCommandWithUnintendedSideEffect
  call cursor(l, c)
endfunction
