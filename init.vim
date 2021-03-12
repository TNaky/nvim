scriptencoding utf-8

if !isdirectory(expand('~/.cache/dein'))
  call system('mkdir -p ~/.cache/dein')
  call system('/bin/sh <(curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh) ~/.cache/dein')
endif

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.config/nvim/color_scheme.toml', {'lazy': 0})

  " Let dein manage dein
  " Required:
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})

  " You can specify revision/branch/tag.
  call dein#add('Shougo/deol.nvim', { 'rev': '01203d4c9' })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#recache_runtimepath()
  call dein#install()
endif

"End dein Scripts-------------------------

if filereadable($HOME . '/.virtualenvs/neovim/bin/python3')
  let g:python3_host_prog = $HOME . '/.virtualenvs/neovim/bin/python3'
endif

" ファイル形式の自動検出
filetype plugin indent on
" シンタックスカラーを有効化
syntax on

" コメントを灰色で表示
hi Comment ctermfg=Gray
" 検索を青色で表示
hi Search ctermfg=Blue

" 文字列の置換を簡単化
nnoremap s/ :%s/
" 文字列検索後のハイライトを解除
noremap <silent> <Esc><Esc> :nohlsearch<Cr>
" vv で行末まで選択
vnoremap v ^$h
" F1をを日本語ヘルプに変更
nnoremap <silent> <F1> :help@ja<Cr>
inoremap <silent> <F1> <ESC>:help@ja<Cr>
" インサートモード時のみESCをjjでも許可
inoremap <silent> jj <ESC>
" 分割された画面の移動
nnoremap <silent><space>h <C-w>h
nnoremap <silent><space>j <C-w>j
nnoremap <silent><space>k <C-w>k
nnoremap <silent><space>l <C-w>l
nnoremap <silent><space>w <C-w>w
nnoremap <silent><space>n :tabnext<Cr>
nnoremap <silent><space>p :tabprevious<Cr>
nnoremap <silent><space>c :tabnew<Cr>

" ファイルフォーマットを指定
set fileformats=unix,dos,mac
set fileencodings=utf-8,sjis
" 常にタブラインを表示
set showtabline=2
" 行番号を表示
set number
" 編集中ファイル名を表示
set title
" 改行時に前行のインデントを継続
set autoindent
" 自動インデントのズレ幅
set shiftwidth=4
" タブ文字の大きさ
set tabstop=2
" タブ文字をスペースで置き換えない
"set noexpandtab
" タブ文字をスペースで置き変える
set expandtab
" 検索時に大文字小文字の区別を行わない
set ignorecase
" 検索時に大文字が入力された場合のみ大文字小文字の区別を行う
set smartcase
" 検索結果が末尾まで進んだら先頭に戻る
set wrapscan
" インクリメンタルサーチを有効化
set incsearch
" 検索結果をハイライト表示
set hlsearch
" タブ文字，行末など不可視文字を可視化
set list
"タブと改行を指定文字で可視化
set listchars=tab:»\ ,eol:¶
" ステータスラインを表示するウィンドウを設定
set laststatus=2
" コマンドをステータスラインに標示
set showcmd
" 現在のモードを標示
set showmode
" ビープ音を鳴らさない
set visualbell
set vb t_vb=
" 256階調色表示
"set t_Co=256
" TrueColor対応
"set termguicolors
" 選択位置を強調
set cursorline
set cursorcolumn
" クリップボードの共有化
set clipboard=unnamed
" フォントを設定
" set guifont=Ricty\ 10

highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight LineNr ctermbg=none
highlight Folded ctermbg=none
highlight EndOfBuffer ctermbg=none

" 全角スペースを表示
function! ZnkakSpace()
  highlight ZnkakSpace cterm=underline ctermfg=grey gui=underline guifg=grey
endfunction

if has('syntax')
  augroup ZnkakSpace
    autocmd!
    " ZnkakSpaceをカラーファイルで設定するなら次の行は削除
    autocmd ColorScheme * call ZnkakSpace()
    " 全角スペースのハイライト指定
    autocmd VimEnter,WinEnter * match ZnkakSpace /　/
    autocmd VimEnter,WinEnter * match ZnkakSpace '\%u3000'
  augroup END
  call ZnkakSpace()
endif

" バイナリ編集（xxd）モード（vim -b で起動，もしくは *.bin ファイルを開くと起動）
augroup Binary
  au!
  au BufReadPre   *.bin let &bin=1
  au BufReadPost  * if &bin | silent %!xxd -g 1
  au BufReadPost  * set filetype=xxd | endif
  au BufWritePre  * if &bin | %!xxd -r
  au BufWritePost * if &bin | silent %!xxd -g 1
  au BufWritePost * set nomod | endif
augroup END

command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! jq \"" . l:arg . "\""
endfunction
