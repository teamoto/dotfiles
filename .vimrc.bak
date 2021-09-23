" This is .vimrc was derived from the following site
" https://qiita.com/kalafinalice/items/9fea87505560d76b5b06


" Features
"" Disable compatible mode
set nocompatible
"" Leave 10000 command history
set history=10000
"" Cursor moving setting
set whichwrap=b,s,h,l,<,>,[,]
"" With w!!, save a file without sudo
cnoremap w!! w !sudo tee > /dev/null %<CR> :e!<CR>
"" Enable backspace
set backspace=indent,eol,start
"" sidescroll by one letter
set sidescroll=1
"" Increase visiblity while side scrolling
set sidescrolloff=8
"" Change encoding to utf8
set encoding=utf-8
"" Make vim compatible with multibite characters such as Japanese
scriptencoding utf-8
"" Change character code to utf8 while saving
set fileencoding=utf-8
"" File encoding priority
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
set fileformats=unix,dos,mac
"" Install NeoVim
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
    if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
        echo "install NeoBundle..."
        :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
    endif
endif
call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" Plugin setting
"" Enable color scheme molokai
NeoBundle 'tomasr/molokai'
"" Enhance status line information
NeoBundle 'itchyny/lightline.vim'
"" Enphasize space at the end of each line
NeoBundle 'bronson/vim-trailing-whitespace'
"" Visualize indent
NeoBundle 'Yggdroot/indentLine'
"" add syntax highlighting plugin for yamal
NeoBundle 'chase/vim-ansible-yaml'
"" NeoVim settings
call neobundle#end()
filetype plugin indent on
NeoBundleCheck
"" Enable molokai if available
if neobundle#is_installed('molokai')
    colorscheme molokai
endif

" Visual-related settings
"" Show status line
set laststatus=2
"" Chagne cursor background
set cursorline
"" Show line number
set number
"" Make sure to show 4 lines above and below of the current line
set scrolloff=4
"" Change color bit to 256
set t_Co=256
"" Show the correspoinding blackets
set showmatch
"" Show command
set showcmd
"" Show the current mode (such as insert, visual, etc...)
set showmode
"" Show the current file name
set title
"" Show the coordinates of the cursor
set ruler
"" Change the shape of caret
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"" Enable sytax coloring
syntax enable
set ambiwidth=double
set showmatch
source $VIMRUNTIME/macros/matchit.vim
set display=lastline

" Input assistant setting
"" Auto-indent
set smartindent
"" smartindent
set shiftwidth=2
"" indent space
set tabstop=4
"" Disable indent while pasting
set paste
"" Change tab to space
set expandtab
"" softtab space to 2
set softtabstop=2
"" auto indent upon pasting
if &term =~ "xterm"
    let &t_SI .= "\e[?2004h"
    let &t_EI .= "\e[?2004l"
    let &pastetoggle = "\e[201~"
    function XTermPasteBegin(ret)
        set paste
        return a:ret
    endfunction
    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
"" Auto-indent after return a line
set autoindent

" Search setting
"" Don't differentiate upper and lower letters
set ignorecase
"" Enable incremental search
set incsearch
set smartcase
"" Highlight search letters
set hlsearch
set wrapscan
