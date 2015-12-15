"=====
" Plug
"=====
call plug#begin()
"Plug 'tpope/vim-sensible'                                                      " opinionated 'sensible' defaults for Vim
Plug 'moll/vim-bbye'                                                            " close files instead of closing views
Plug 'tpope/vim-fugitive'                                                       " Git integration
Plug 'scrooloose/nerdcommenter'                                                 " nicer (un)comment commands
Plug 'scrooloose/nerdtree'                                                      " sidebar file browser
Plug 'scrooloose/syntastic'                                                     " code and style checks
Plug 'altercation/vim-colors-solarized'                                         " best colorscheme of them all
Plug 'majutsushi/tagbar'                                                        " sidebar code structure browser
Plug 'klen/python-mode'                                                         " Python goodies
Plug 'davidhalter/jedi-vim'                                                     " Python code completion and refactoring
Plug 'Rykka/riv.vim'                                                            " reStructured text goodies
Plug 'kien/ctrlp.vim'                                                           " command line fuzzy file search and open
Plug 'rking/ag.vim'                                                             " ag integration (the silver searcher
Plug 'Valloric/YouCompleteMe', { 'do': 'python install.py --clang-completer' }  " autocompletion
"Plug 'lervag/vimtex'                                                           " (La)TeX goodies
call plug#end()

" FIXME - Vundle leftovers, need to test if I need them back or not
"filetype off                 " required for Vundle
"filetype plugin indent on    " required for Vundle
"filetype plugin on           " use this instead of ^ to ignore plugin indent changes

"==========
" Solarized
"==========
set background=dark
:silent! colorscheme solarized

"=====
"Ag
"=====
let g:ag_working_path_mode="r"  " always start searching from project root 

"=====
"CtrlP
"=====
let g:ctrlp_cmd = 'CtrlPMixed'

"=====
" Jedi
"=====
" Change default binding of jedi's rename command
let g:jedi#rename_command = "<leader>rn"
" Do not use Jedi for autocompletion (using YCM for that)
let g:jedi#completions_enabled = 0
" Set function call signatures display
" 0 - turned off
" 1 - pop-up (easier to refer to)
" 2 - vim's command line (nicer undo history)
let g:jedi#show_call_signatures = "1"

"============
" Python-mode
"============
let g:pymode = 1

" disable some features in favor of Jedi and YCM
let g:pymode_rope = 0
let g:pymode_doc = 0

" trim whitespace on save
let g:pymode_trim_whitespaces = 1
" load some code formatting defaults
let g:pymode_options = 1

" use PEP8-compatible indent
let g:pymode_indent = 1
" use advanced pymode folding
let g:pymode_folding = 1
" use pymode motions
let g:pymode_motion = 1
" use virualenv support
let g:pymode_virtualenv = 1

" use running the code facilities
let g:pymode_run = 1
let g:pymode_run_key = '<leader>r'

" use inserting breakpoints
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

" Code checking - disable (use Syntastic for this)
let g:pymode_lint = 0

" Pymode custom syntax highlight
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1

"==========
" Syntastic
"==========
" Define nice error symbols
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

" Allways stick found errors to loclist
let g:syntastic_always_populate_loc_list=1
" Automatically close and open loclist
let g:syntastic_auto_loc_list=1
" Aggregate errors from all checkers
let g:syntastic_aggregate_errors=1

" Use flake8 as a sole checker for Python files
" Available are pep8,pep257,pyflakes,pylint,py3kwarn,python,flake8,pylama
let g:syntastic_python_checkers = ['flake8']

"=========
" NERDTree
"=========

" filter on *.pyc files in NERDTree plugin
let NERDTreeIgnore = ['\.pyc$']

" Key to toggle NERDTree sidebar
map <F3> :NERDTreeToggle<CR>

"=============
"NERDCommenter
"=============
" Use hash for comments in ini/conf files, keep ; as alternative
let g:NERDCustomDelimiters = {
    \ 'dosini': {'left': '#', 'leftAlt': ';'}
    \ }

"=======
" Tagbar
"=======
let g:tagbar_width = 32

" Key to toggle TagBar sidebar
nmap <F4> :TagbarToggle<CR>

"====
" Riv
"====
" output path for converted file _not_ in projects
let g:riv_temp_path = 0  " the same dir as source

" highlight Python docstrings as RST
let g:riv_python_rst_hl = 1
" use this highlighting (otherwise interferes? with python highlighting)
let g:riv_highlight_code = 'python'

"==========
" Powerline
"==========
set laststatus=2
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
