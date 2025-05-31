" configure generic file handling
filetype on         " enable filetype detection
filetype plugin on  " enable filetype plugins

" configure indentation and tab behavior
set autoindent      " use indentation of previous line
set smartindent     " use intelligent indentation for C
"set softtabstop=4   " tab width is 4 spaces
"set tabstop=4
"set shiftwidth=4    " indent also with 4 spaces
set softtabstop=2   " tab width is 2 spaces
set tabstop=2
set shiftwidth=2    " indent also with 2 spaces
set expandtab       " expand tabs to spaces
set textwidth=80    " wrap lines at 80 chars

" configure colors
set t_Co=256        " use 256 terminal colors
syntax on           " turn syntax highlighting on
set background=dark
colorscheme jellybeans  " set colorscheme
"colorscheme gruvbox



" misc options
set showmatch       " highlight matching braces
set vb t_vb=        " disable beeps on error
set ruler           " line,column display at bottom of screen
set incsearch       " enable incremental search while typing
set number          " turn line numbers on
set wrap linebreak textwidth=0 "ensures no implicit linebreaks
set nocp            " forget about compatibility with old version of vi

" ---- All below here added, not in my github file ------- "

set mouse=a " allows for scrolling in vim terminal
autocmd Filetype python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
set viminfo='100,<1000,s100,h
set completeopt-=preview "No scratch pad preview when using YCM 

"Open terminal window at bottom of screen with 15 rows
nnoremap bt :bo term ++rows=15<CR> 
"Open vertical terminal to the left (can't see option to make to the right)
nnoremap vt :vert term <CR> 
" double esc to set vim terminal to pause vim terminal
tnoremap <Esc><Esc> <C-\><C-n>
" gt to use YouCompleteMe GoTo feature
nnoremap gt :YcmCompleter GoTo<CR>
" jumplist go back 
nnoremap bk <C-O> 
" jumplist go forward
nnoremap fwd <C-I>
"setup vim gdb termdebug command, use :TermdebugCommand <debug-binary> <args>
nnoremap gdb :TermdebugCommand 
" setup auto clang format on c, cpp files
autocmd FileType c,cpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp vnoremap <buffer><Leader>cf :ClangFormat<CR>

" switch between header/source with F4
map <F4> :e %:p:s,.hpp$,.X123X,:s,.cpp$,.hpp,:s,.X123X$,.cpp,<CR>
" switch between header/source with F5 for .C/.H files
map <F5> :e %:p:s,.H$,.X123X,:s,.C$,.H,:s,.X123X$,.C,<CR>

" START -- Added based on Developer vim setup wiki: https://cqs-wiki.citadelgroup.com/display/DT/VIM
let mm_share = '/auto/mm_coretech/devtools/devtools-stable/share/'
let mm_plugin_dir = mm_share . 'vim-packages/'
set encoding=utf-8 "Added for the  YouCompleteMe plugin below, get error without this

let nix_share = '/nix/linux-tools/23.11/default/share/'
let nix_plugin_dir = nix_share . 'vim-plugins/'

" Github Copilot setup
let g:copilot_proxy = 'http://proxy.gtm.citadelgroup.com:80/'
let local_config_dir = '~/.config/vim/'
let local_plugin_dir = local_config_dir . 'plugins/'

" for vim-polyglot, per Github 
" set nocompatible

call plug#begin()
" Plug plugin_dir . PLUGIN_NAME
 Plug mm_plugin_dir . 'YouCompleteMe'
 let g:ycm_show_diagnostics_ui = 0 " Turn off highlighting for semantic analysis
 let g:ycm_enable_diagnostic_signs = 0
 let g:ycm_global_ycm_extra_conf = '~/.vim/bazel_ycm_conf/ycm_extra_conf.py'
 
 "Plug mm_plugin_dir . 'vim-fugitive'
 "Plug mm_plugin_dir . 'vim-clang-format'
  Plug nix_plugin_dir . 'vim-fugitive'
  Plug nix_plugin_dir . 'vim-clang-format'

  Plug nix_share . 'vim-plugins/fzf'
  Plug nix_plugin_dir . 'fzf.vim'
  "Plug nix_plugin_dir . 'vim-polyglot'

  " Copilot setup
  Plug local_plugin_dir . 'copilot.vim-1.22.0'

call plug#end()
" END changes from wiki

" Setup FZF keybindings
nnoremap fs :FZF<CR>
nnoremap <Space>sg :Rg<CR>

" Setup Termdebug command 
packadd! termdebug
let g:termdebug_wide = 1

" Setup Copilot keybindings
let g:copilot_no_tab_map = 1
" Map control space to accept copilot suggestion
inoremap <expr> <C-Space> copilot#Accept()
