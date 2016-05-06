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
			\ -g ""'
let g:ctrlp_max_files=0

" Settings for ag
let g:ag_prg='ag -S  --nogroup  --nocolor --column --ignore sitedata --ignore image --ignore "tags" --ignore "*~"'

set softtabstop=8
set shiftwidth=8

let &termencoding=&encoding
set fileencodings=utf-8,gbk

" For solarized color scheme
"syntax enable
"set background=dark
"colorscheme solarized
"set guifont=Monospace\ 14

" Use the color style as that in gvim by setting below
set t_Co=16


