let mapleader = " "        " Use space as leader instead of '\'
set mouse=a         " allows for scrolling in vim buffer

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

"File operations
set autoread
set noswapfile

" File explorer stuff
"" Netrw settings (built-in file explorer)
let g:netrw_banner = 0        " hide banner
let g:netrw_liststyle = 3     " tree view
let g:netrw_winsize = 25      " 25% width when splitting
nnoremap <leader>e :Explore<CR>

" Color configuration with fallbacks
" Always set 256 colors as baseline
set t_Co=256
" Enable true colors if available (this enhances the 256 color mode)
if has('termguicolors') && $COLORTERM == 'truecolor'
    set termguicolors
endif

syntax enable            " Enable syntax highlighting

" Try jellybeans first, then built-in fallbacks
try
    colorscheme jellybeans    " Your preferred theme
catch
    colorscheme habamax   " Modern built-in (Vim 8.2+)
endtry

" misc options
set showmatch       " highlight matching braces
set vb t_vb=        " disable beeps on error
set ruler           " line,column display at bottom of screen
set incsearch       " enable incremental search while typing
set number          " turn line numbers on
set wrap linebreak textwidth=0 "ensures no implicit linebreaks
set nocp            " forget about compatibility with old version of vi

set hlsearch        " turn on search higlighting
" viminfo config, save marks for last 100 files, save up to 1000 lines for each
" register, skip registers >100kb, clear search highlighting on vim start
set viminfo='100,<1000,s100,h
" Clear search highlighting with double escape in normal mode
nnoremap <Esc><Esc> :nohlsearch<CR>


"Open terminal window at bottom of screen with 15 rows
nnoremap bt :bo term ++rows=15<CR>
"Open vertical terminal to the left (can't see option to make to the right)
nnoremap vt :vert term <CR>
" double esc to set vim terminal to pause vim terminal
tnoremap <Esc><Esc> <C-\><C-n>

" configure shortcuts/hotkeys
" switch between header/source with F4
map <F4> :e %:p:s,.hh$,.X123X,:s,.cc$,.hh,:s,.X123X$,.cc,<CR>

" Setup Termdebug command 
packadd! termdebug
let g:termdebug_wide = 1
nnoremap gdb :TermdebugCommand<Space>
