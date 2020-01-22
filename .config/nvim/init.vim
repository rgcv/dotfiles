if !has('nvim')
  set encoding=utf-8
  filetype plugin indent on
endif
scriptencoding utf-8

"   __   __        _
"  / / __\ \__   _(_)_ __ ___
" | | '_ \| \ \ / / | '_ ` _ \
" | | | | | |\ V /| | | | | | |
" | |_| |_| | \_/ |_|_| |_| |_|
"  \_\   /_/

" https://gist.github.com/laggardkernel/9013f948345212563ede9c9ee56c6b42
" Reuse nvim's rtp and packpath in vim
if !has('nvim') && v:version >= 800
  set runtimepath-=~/.vim
    \ runtimepath^=~/.local/share/nvim/site runtimepath^=~/.vim
    \ runtimepath-=~/.vim/after
    \ runtimepath+=~/.local/share/nvim/site/after runtimepath+=~/.vim/after
  let &packpath = &runtimepath
endif

"" plugins
if empty(glob('~/.local/share/nvim/plugged'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.github.com/junegunn/vim-plug/master/plug.vim
endif

function! When(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin('~/.local/share/nvim/plugged')
Plug 'AndrewRadev/tagalong.vim'
Plug 'airblade/vim-gitgutter'
Plug 'ararslan/license-to-vim'
Plug 'chr4/nginx.vim'
Plug 'chriskempson/base16-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'itchyny/lightline.vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-slash'
Plug 'lepture/vim-jinja'
Plug 'lervag/vimtex'
Plug 'lilydjwg/colorizer'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
Plug 'mattn/emmet-vim'
Plug 'mike-hearn/base16-vim-lightline'
Plug 'neomake/neomake'
  Plug 'sinetoami/lightline-neomake'
Plug 'Potatoesmaster/i3-vim-syntax'
Plug 'pangloss/vim-javascript'
Plug 'roxma/vim-paste-easy'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'roxma/nvim-yarp', When(!has('nvim'))
  Plug 'roxma/vim-hug-neovim-rpc', When(!has('nvim'))
  Plug 'deoplete-plugins/deoplete-clang'
  Plug 'deoplete-plugins/deoplete-jedi'
  Plug 'deoplete-plugins/deoplete-go', { 'do': 'make' }
  Plug 'deoplete-plugins/deoplete-zsh'
  Plug 'Shougo/neoinclude.vim'
Plug 'Shougo/echodoc'
Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'udalov/kotlin-vim'
Plug 'vim-pandoc/vim-pandoc'
  Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'visualfc/gocode',
      \ { 'rtp': (has('nivm') ? 'n' : '').'vim',
      \   'do': '~/.local/share/nvim/plugged/gocode/nvim/symlink.sh' }
call plug#end()

" options
if !has('nvim')
  " nvim defaults
  set autoindent
  set autoread
  set background=dark
  set backspace=indent,eol,start
  set belloff=all
  set complete-=i
  set cscopeverbose
  set display="lastline,msgsep"
  set fillchars="vert:│,fold:·"
  set formatoptions=tcqj
  set history=10000
  set hlsearch
  set incsearch
  set langnoremap
  set laststatus=2
  set listchars="tab:> ,trail:-,nbsp:+"
  set nrformats=bin,hex
  set ruler
  set sessionoptions-=options
  set shortmess+=F shortmess-=S
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

  set nofsync
  set nolangremap
  " vint: -ProhibitSetNoCompatible
  set nocompatible
  " vint: +ProhibitSetNoCompatible
endif

set clipboard=unnamed,unnamedplus " yank to X + primary clipboards
set colorcolumn=+1
set expandtab " I like spaces, don't @ me
set mouse=a " enable mouse support if we have it
set number relativenumber
set shiftwidth=2
set scrolloff=8 sidescrolloff=8
set signcolumn=yes " always show gutter
set smartindent
set splitbelow splitright
set termguicolors
if !has('gui_running')
  set t_Co=256
endif

set noshowmode " redundant with lightline/airline/powerline
set nowrap

colorscheme base16-material-darker

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
" deoplete
let g:deoplete#enable_at_startup = has('+python3')
call g:deoplete#custom#var('omni', 'input_patterns', {
      \ 'tex': g:vimtex#re#deoplete
      \ })
" deoplete-clang
let g:deoplete#sources#clang#libclang_path = '/usr/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'
" deoplete-go
let g:deoplete#sources#go#sort_class = [
      \ 'package',
      \ 'func',
      \ 'type',
      \ 'var',
      \ 'const',
      \ ]
" echodoc
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'floating'
" ftplugin
let g:tex_flavor = 'latex'
" license-to-vim
let g:license_author = 'Rui Ventura'
command! Mit License('mit')
" lightline.vim
let g:lightline = {
      \ 'colorscheme': 'base16_material_darker',
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
        \ &filetype ==# 'tagbar' && has_key(g:lightline, 'fname') ?
          \ g:lightline.fname :
        \ &filetype ==# 'vim-plug' ? '' :
        \ ''
          \ . (&modified ? '*' : '')
          \ . (filename !=# '' ? filename : '[untitled]')
endfunction

function! LightlineFiletype()
  return winwidth(0) <= 70 ? '' :
        \ &filetype =~# 'ctrlp\|tagbar\|vim-plug' ? '' :
        \ &filetype !=# '' ? &filetype :
        \ 'no ft'
endfunction

function! LightlineFugitive()
  if exists('*fugitive#head')
    let head = fugitive#head()
    return head !=# '' ? ' ' . head : ''
  else
    return ''
  endif
endfunction

function! LightlineMode()
  return
        \ &filetype =~# 'ctrlp\|help\|tagbar\|vim-plug' ? toupper(&filetype) :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction
" lightline-neomake
let g:lightline#neomake#prefix_ok = '✓ '
let g:lightline#neomake#prefix_errors = '✗ '
let g:lightline#neomake#prefix_infos = '¡ '
let g:lightline#neomake#prefix_warnings = '!! '
" markdown-preview.nvim
nmap <leader>mp <Plug>MarkdownPreview
" NERDTree
nnoremap <c-e> :NERDTreeToggle<CR>
" neomake
silent! call neomake#configure#automake('nrwi', 750)
" neosnippet
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif
" tagbar
let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
  let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

nmap <c-t> :TagbarToggle<CR>
" vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
" vim-pandoc
let g:pandoc#modules#disabled = ['folding']
" vim-plug
command! PU PlugUpdate | PlugUpgrade
" vimtex
let g:vimtex_compiler_latexmk = {
      \ 'backend': 'nvim',
      \ 'background': 1,
      \ 'build_dir': '',
      \ 'callback': 1,
      \ 'continuous': 1,
      \ 'executable': 'latexmk',
      \ 'hooks': [],
      \ 'options': [
      \   '-verbose',
      \   '-shell-escape',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'zathura'
let g:vimtex_viewer_zathura_options
      \ = '-x "nvr --servername ' . v:servername . ' --remote +\%{line} \%{input}"'
      \ . '--synctex-forward @line:@col:@tex g:syncpdf'

" autocmds
augroup init#configs
  autocmd!
  autocmd BufWritePost $MYVIMRC nested source %

  autocmd BufWritePost ~/.config/dunst/dunstrc
        \ silent !systemctl --user restart dunst
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
