" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2014 Feb 05
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

filetype off                  " required

"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'Chiel92/vim-autoformat'
Plugin 'vim-syntastic/syntastic'

Plugin 'Valloric/YouCompleteMe'

Plugin 'easymotion/vim-easymotion'


" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
"Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
"Plugin 'L9'
" Git plugin not hosted on GitHub
"Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
"Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line





" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
"  set mouse=a
"endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

set tabline=%!MyTabLine()  " custom tab pages line
function MyTabLine()
    let s = '' " complete tabline goes here
    " loop through each tab page
    for t in range(tabpagenr('$'))
        " set highlight
        if t + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        " set the tab page number (for mouse clicks)
        let s .= '%' . (t + 1) . 'T'
        let s .= ' '
        " set page number string
        let s .= t + 1 . ' '
        " get buffer names and statuses
        let n = ''      "temp string for buffer names while we loop and check buftype
        let m = 0       " &modified counter
        let bc = len(tabpagebuflist(t + 1))     "counter to avoid last ' '
        " loop through each buffer in a tab
        for b in tabpagebuflist(t + 1)
            " buffer types: quickfix gets a [Q], help gets [H]{base fname}
            " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
            if getbufvar( b, "&buftype" ) == 'help'
                let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
            elseif getbufvar( b, "&buftype" ) == 'quickfix'
                let n .= '[Q]'
            else
                let n .= pathshorten(bufname(b))
            endif
            " check and ++ tab's &modified count
            if getbufvar( b, "&modified" )
                let m += 1
            endif
            " no final ' ' added...formatting looks better done later
            if bc > 1
                let n .= ' '
            endif
            let bc -= 1
        endfor
        " add modified label [n+] where n pages in tab are modified
        if m > 0
            let s .= '[' . m . '+]'
        endif
        " select the highlighting for the buffer names
        " my default highlighting only underlines the active tab
        " buffer names.
        if t + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        " add buffer names
        if n == ''
            let s.= '[New]'
        else
            let s .= n
        endif
        " switch to no underlining and add final space to buffer list
        let s .= ' '
    endfor
    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'
    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLineFill#999Xclose'
    endif
    return s
endfunction

runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
Helptags

" Settings for ctrlp to use ag instend of grep
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
                            \ --ignore .git
                            \ --ignore .svn
                            \ --ignore .hg
                            \ --ignore .DS_Store
                            \ --ignore "**/*.pyc"
                            \ --ignore "**/*.swp"
                            \ --ignore "*~"
                            \ --ignore "**/*.yml"
                            \ --ignore "**/*.jpg"
                            \ --ignore "**/*.png"
                            \ --ignore "**/*.gif"
                            \ --ignore "**/*.doc"
                            \ --ignore "**/*.html"
                            \ --ignore "**/*.htm"
                            \ -g ""'
let g:ctrlp_max_files=0
let g:ctrlp_match_window = 'order:ttb,min:1,max:10,results:60'
let g:ctrlp_working_path_mode = 'w'

" Settings for ag
let g:ag_prg='ag -S  --nogroup  --nocolor --column --ignore sitedata --ignore image --ignore "tags" --ignore "*~"'

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

let &termencoding=&encoding
set fileencodings=utf-8,gbk

" For solarized color scheme
" syntax enable
" set background=dark
" colorscheme solarized
" set guifont=Monospace\ 14

" Use the color style as that in gvim by setting below
set t_Co=16

set number
set relativenumber

" Tab is showing as '>---', you can command 'set list/nolist' to enable or disable
" showing the Tab and trail blanks
set listchars=tab:>-,trail:-

"clang-format for formating cpp code
nnoremap <leader>gf :call FormatCodeN("Google")<cr>
nnoremap <leader>wf :call FormatCodeN("WebKit")<cr>
vnoremap <leader>gf :call FormatCodeV("Google")<CR>
vnoremap <leader>wf :call FormatCodeV("WebKit")<cr>

let g:autoformat_verbosemode = 0

func FormatCodeV(style)
  let firstline=line(".")
  let lastline=line(".")
  " Visual mode
  if exists(a:firstline)
    firstline = a:firstline
    lastline = a:lastline
  endif
  let g:formatdef_clangformat = "'clang-format --lines='.a:firstline.':'.a:lastline.' --assume-filename='.bufname('%').' -style=" . a:style . "'"
  let formatcommand = ":" . firstline . "," . lastline . "Autoformat"
  exec formatcommand
endfunc

func FormatCodeN(style)
  let firstline=line("0")
  let lastline=line("$")

  let g:formatdef_clangformat = "'clang-format --lines='.a:firstline.':'.a:lastline.' --assume-filename='.bufname('%').' -style=" . a:style . "'"
  let formatcommand = ":" . firstline . "," . lastline . "Autoformat"
  exec formatcommand
endfunc

set cursorline

" For DoxygenToolkit
let g:DoxygenToolkit_briefTag_funcName = "yes"

" for C++ style, change the '@' to '\'
let g:DoxygenToolkit_commentType = "C++"
let g:DoxygenToolkit_briefTag_pre = "@brief   "
let g:DoxygenToolkit_templateParamTag_pre = "@param "
let g:DoxygenToolkit_paramTag_pre = "@param "
let g:DoxygenToolkit_returnTag = "@return "
let g:DoxygenToolkit_throwTag_pre = "@throw " " @exception is also valid
let g:DoxygenToolkit_fileTag = "@file    "
let g:DoxygenToolkit_dateTag = "@date    "
let g:DoxygenToolkit_authorTag = "@author  "
let g:DoxygenToolkit_versionTag = "@version "
let g:DoxygenToolkit_blockTag = "@name "
let g:DoxygenToolkit_classTag = "@class "
let g:DoxygenToolkit_authorName = "Paul.Hu <zhuqing.hzq@alibaba-inc.com>"
let g:DoxygenToolkit_licenseTag = "Copyright (C) Alibaba-Inc."
let g:doxygen_enhanced_color = 1

" For easymotion
map <leader> <Plug>(easymotion-prefix)

" For YouCompleteMe
let g:ycm_error_symbol = 'x'
let g:ycm_warning_symbol = '!'
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_server_python_interpreter='/usr/bin/python'
"let g:ycm_confirm_extra_conf = 0'~/.vim/.ycm_extra_conf.py'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'


let g:syntastic_always_populate_loc_list = 1
let g:syntastic_enable_highlighting = 0

let g:ttimeoutlen = 0

set guifont=Courier\ New\ 12

inoremap jj <Esc>

autocmd FileType c,cc,cpp,h,hpp,python,ruby,java,sh,html,javascript autocmd BufWritePre <buffer> :%s/\s\+$//e
