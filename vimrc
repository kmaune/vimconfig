" configure generic file handling
filetype on         " enable filetype detection
filetype plugin on  " enable filetype plugins

" configure indentation and tab behavior
set autoindent      " use indentation of previous line
set smartindent     " use intelligent indentation for C
set softtabstop=2   " tab width is 4 spaces
set shiftwidth=2    " indent also with 4 spaces
set expandtab       " expand tabs to spaces
set textwidth=80    " wrap lines at 80 chars

" configure colors
set t_Co=256        " use 256 terminal colors
syntax on           " turn syntax highlighting on
colorscheme jellybeans  " set colorscheme

" misc options
set showmatch       " highlight matching braces
set vb t_vb=        " disable beeps on error
set ruler           " line,column display at bottom of screen
set incsearch       " enable incremental search while typing
set number          " turn line numbers on
set wrap linebreak textwidth=0 "ensures no implicit linebreaks
set nocp            " forget about compatibility with old version of vi


" configure shortcuts/hotkeys
" switch between header/source with F4
map <F4> :e %:p:s,.hh$,.X123X,:s,.cc$,.hh,:s,.X123X$,.cc,<CR>
" recreate tags file with F5
map <F5> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
" create doxygen function/method comment with F6
map <F6> :Dox<CR>
" create doxygen class comment with F7
map <F7> :DoxAuthor<CR>
" goto definition with F12
map <F12> <C-]>

" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
