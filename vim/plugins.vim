"=====
" Plug
"=====
call plug#begin()
Plug 'moll/vim-bbye'                     " close files instead of closing views
Plug 'tpope/vim-fugitive'                " Git integration
Plug 'scrooloose/nerdcommenter'          " nicer (un)comment commands
Plug 'scrooloose/nerdtree'               " sidebar file browser
Plug 'scrooloose/syntastic'              " code and style checks
Plug 'altercation/vim-colors-solarized'  " best colorscheme of them all
Plug 'majutsushi/tagbar'                 " sidebar code structure browser
Plug 'klen/python-mode'                  " Python goodies
Plug 'davidhalter/jedi-vim'              " Python code completion and refactoring
Plug 'Rykka/riv.vim'                     " reStructured text goodies
Plug 'ctrlpvim/ctrlp.vim'                " command line fuzzy file search and open
Plug 'mileszs/ack.vim'                   " ack/ag integration
Plug 'Shougo/neocomplete'                " auto-complete, supports Jedi for Python code 
Plug 'vim-airline/vim-airline'           " lightweight alternative to Powerline
Plug 'vim-airline/vim-airline-themes'    " additional themes for vim-airline
Plug 'edkolev/tmuxline.vim'              " generate Powerline-like config for Tmux interface, based on vim-airline
Plug 'edkolev/promptline.vim'            " generate Powerline-like config for shell command line, based on vim-airline
Plug 'Konfekt/FastFold'                  " improves folding, speeds up neocomplete
Plug 'metakirby5/codi.vim'               " Online REPL sidepanel
Plug 'airblade/vim-gitgutter'            " display git status per line in buffer, stage/instage hunks, integrates with vim-airline
Plug 'diepm/vim-rest-console'            " interact with JSON-based REST APIs
"Plug 'lervag/vimtex'                     " (La)TeX goodies
"Plug 'tpope/vim-sensible'                " opinionated 'sensible' defaults for Vim
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
"Ack
"=====
if executable('ag')
    let g:ackprg = 'ag --vimgrep --smart-case'
    cnoreabbrev ag Ack
    cnoreabbrev aG Ack
    cnoreabbrev Ag Ack
    cnoreabbrev AG Ack
endif
let g:ackhighlight = 1

"=====
"CtrlP
"=====
let g:ctrlp_cmd = 'CtrlPMixed'

"=====
" Jedi
"=====
" Do not use Jedi for autocompletion (using neocomplete for that)
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0
let g:jedi#smart_auto_mappings = 0
" Change default binding of jedi's rename command
let g:jedi#rename_command = "<leader>rn"
" Set function call signatures display
" 0 - turned off
" 1 - pop-up (easier to refer to)
" 2 - vim's command line (nicer undo history)
let g:jedi#show_call_signatures = 1
" Use tabs for go-to commands
let g:jedi#use_tabs_not_buffers = 1

"============
" Neocomplete
"============
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" Python / jedi-vim completion
autocmd FileType python setlocal omnifunc=jedi#completions
if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" Other completions (builtin)
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" Key-mappings are in keymaps.vim

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
" Use octothorpe for comments in ini/conf files, keep ; as alternative
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

"========
" Airline
"========
let g:airline_powerline_fonts = 1
let g:airline_theme='powerlineish'
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#promptline#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#tabline#enabled = 0
"
"===========
" Promptline
"===========
"
let g:promptline_theme = 'powerlineclone'
:silent! let g:promptline_preset = {
        \'a' : [ promptline#slices#host() ],
        \'b' : [ promptline#slices#user() ],
        \'c' : [ promptline#slices#python_virtualenv() ],
        \'x' : [ promptline#slices#vcs_branch(), promptline#slices#git_status(), ],
        \'y' : [ promptline#slices#cwd({ 'dir_limit':2 }) ],
        \'z' : [ promptline#slices#jobs() ],
        \'warn' : [ promptline#slices#last_exit_code() ]}
