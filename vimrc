" Skip initialization for vim-tiny or vim-small.
if 0 | endif

filetype off

if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" originalrepos on github
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
  \ 'build' : {
    \ 'windows' : 'make -f make_mingw32.mak',
    \ 'cygwin' : 'make -f make_cygwin.mak',
    \ 'mac' : 'make -f make_mac.mak',
    \ 'unix' : 'make -f make_unix.mak',
  \ },
\ }
NeoBundle 'VimClojure'
NeoBundle 'Shougo/vimshell'
NeoBundle "Shougo/unite.vim"
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'jpalardy/vim-slime'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 't9md/vim-textmanip'
NeoBundle 'tomasr/molokai'
NeoBundle 'simeji/winresizer'
NeoBundle "ctrlpvim/ctrlp.vim"
""NeoBundle 'https://bitbucket.org/kovisoft/slimv'

call neobundle#end()

filetype plugin indent on     " required!
filetype indent on
set t_Co=256
syntax on
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,cp932

set tabstop=4
set expandtab
set shiftwidth=4
set autoindent
set number
set hlsearch
set grepprg=ag

set backupdir=$HOME/.vim/backup
set directory=$HOME/.vim/swap

set list
set listchars=tab:>-,extends:<,trail:-
set statusline=%F%m%r%h%w\%=[ASCII=\%03.3b]\[HEX=\%02.2B]\[POS=%05l/%05L,%05v][%p%%]

"multibyte
set ambiwidth=double

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ


colorscheme molokai
let mapleader = ","
"" neocomplcache
autocmd BufRead *.php\|*.ctp\|*.tpl :set dictionary=~/.vim/dictionaries/php.dict filetype=php
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : ''
    \ }

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "<CR>"
inoremap <expr><C-e>  neocomplcache#cancel_popup()

" insert modeで開始
let g:unite_enable_start_insert = 1

" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

nnoremap <silent> ,b  :<C-u>Unite buffer<CR>
" grep検索
nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

" カーソル位置の単語をgrep検索
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
nnoremap <silent> ,fm :<C-u>Unite file_mru buffer<CR>

" grep検索結果の再呼出
nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>

call unite#custom#default_action('file,buffer' , 'vsplitswitch')

let s:unite_action = {
\   'is_selectable': 1,
\ }

unlet! s:unite_action
" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

"vimfiler
let g:vimfiler_safe_mode_by_default = 0
nnoremap <silent> fi :<C-u>VimFiler -split -simple -winwidth=35 -no-quit<CR>
nnoremap <leader> e :VimFilerExplore -split -winwidth=35 -find -no-quit<Cr>
