" Custom vimrc file.
"
" Owner: Cam Sexton
" camsexton.com
"
" This is loaded unless Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.


""""""""""BASE SETTINGS""""""""""""
" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif
"
" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

"""""""""""""""" MY SETTINGS """""""""""""""""""""""

" 
" VIM specific (not plugin) settings
"
:let mapleader = "\<Space>"
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab " set default tab width to 2
set number
hi VertSplit cterm=NONE gui=NONE " minimal vertical split when two files open
let NERDTreeShowHidden=1
if $TERM == "alacritty"
  set termguicolors
endif
colorscheme papaya
let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

autocmd BufEnter * :syntax sync fromstart
autocmd BufNewFile,BufReadPost *.hbs set filetype=pug
" Moving lines/blocks up and down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" Insert newline at cursor
nnoremap <A-o> i<CR><ESC>k$

call plug#begin('~/.vim/plugged')
Plug 'https://github.com/scrooloose/nerdtree.git'
Plug 'https://github.com/lumiliet/vim-twig.git'
Plug 'junegunn/fzf.vim'
Plug 'https://github.com/Raimondi/delimitMate.git'
Plug 'posva/vim-vue'
Plug 'https://github.com/digitaltoad/vim-pug.git'
"Plug 'gabrielelana/vim-markdown'
Plug 'https://github.com/kchmck/vim-coffee-script.git'
Plug 'https://github.com/supercollider/scvim.git'
Plug 'https://github.com/terryma/vim-smooth-scroll.git'
Plug 'https://github.com/Valloric/YouCompleteMe.git'
Plug 'https://github.com/mxw/vim-jsx.git'
Plug 'pangloss/vim-javascript'
Plug 'ambv/black'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
call plug#end()

"
" delimitMate Settings
"

let delimitMate_expand_cr = 2

"
" FZF Mapping
"
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":FZF\<cr>"

" NERDTree Settings
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif " Start NERDTree if no command line args
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif " Start NERDTree if opening a folder
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif " close NERDTree with vim
nmap q :NERDTreeToggle<CR> " open/close NERDTree
map <TAB> <C-w>w " switch cursor to next split
if has('nvim')
	map <M-Tab> <C-w>h " switch cursor to previous split
endif
let NERDTreeMinimalUI = 1

" 
" SCVim Settings
"
" let g:sclangTerm = "xterm -fn '-*-fixed-medium-*-*-*-40-*-*-*-*-*-*-*' -rv -bd black -ls -xrm 'XTerm*selectToClipboard: true'"
let g:sclangTerm = "xterm -fa monaco -fs 13 -bg black -fg green -ls -xrm 'XTerm*selectToClipboard: true'"
let g:sclangPipeApp = "~/.vim/plugged/scvim/bin/start_pipe"
let g:sclangDispatcher = "~/.vim/plugged/scvim/bin/sc_dispatcher"
let g:scFlash = 1
au Filetype supercollider nnoremap <buffer> <leader><CR> :call SClang_block()<CR>
au Filetype supercollider vnoremap <buffer> <leader><CR> :call SClang_send()<CR>
au Filetype supercollider nnoremap <buffer> <leader>h :call SClang_line()<CR>
au Filetype supercollider nnoremap <buffer> <leader>. :call SClangHardstop()<CR>

"
" YouCompleteMe Settings
"
" let g:ycm_autoclose_preview_window_after_insertion = 1
" let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_collect_identifiers_from_tags_files = 1

"
" smooth scroll settings
"
noremap <silent> <c-k> :call smooth_scroll#up(10, 10, 1)<CR>
noremap <silent> <c-j> :call smooth_scroll#down(10, 10, 1)<CR>

" Black
autocmd BufWritePre *.py execute ':Black'
