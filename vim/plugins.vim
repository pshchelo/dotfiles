"=====
" Plug
"=====
call plug#begin()
" auto-set paste mode when inserting thru terminal shortcut keys
Plug 'ConradIrwin/vim-bracketed-paste'
" close files instead of closing views
Plug 'moll/vim-bbye'
" command line fuzzy file search and open
Plug 'ctrlpvim/ctrlp.vim'
" ack/ag integration
Plug 'mileszs/ack.vim'
" Git integration
Plug 'tpope/vim-fugitive'
" display git status per line in buffer, stage/instage hunks, integrates with vim-airline
Plug 'airblade/vim-gitgutter'
" nicer (un)comment commands
Plug 'scrooloose/nerdcommenter'
" code and style checks
Plug 'scrooloose/syntastic'
" auto-complete, supports Jedi for Python code
Plug 'Shougo/neocomplete' | Plug 'Konfekt/FastFold'
" Python goodies
Plug 'klen/python-mode', { 'for': 'python' }
" Python code completion and refactoring
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
" reStructured text goodies - using a fork until this commit is merged to Rykka/riv.vim:master
Plug 'proteansec/riv.vim', { 'branch': 'fixdel', 'for': 'rst,python' }
" sidebar file browser
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
" sidebar code structure browser, requires exuberant-tags to be installed
Plug 'majutsushi/tagbar' " not enable it on toggle as airline can not lazy-load its plugins
" use vimdiff on folders!
Plug 'will133/vim-dirdiff'
" best colorscheme of them all
Plug 'altercation/vim-colors-solarized'
" lightweight alternative to Powerline
Plug 'vim-airline/vim-airline'
" additional themes for vim-airline
Plug 'vim-airline/vim-airline-themes'
" generate Powerline-like config for Tmux interface, based on vim-airline
Plug 'edkolev/tmuxline.vim', { 'on': 'Tmuxline' }
" generate Powerline-like config for shell command line, based on vim-airline
Plug 'edkolev/promptline.vim', { 'on': 'PromptlineSnapshot' }
" Online REPL sidepanel
Plug 'metakirby5/codi.vim', { 'on': 'Codi' }
" interact with JSON-based REST APIs
Plug 'diepm/vim-rest-console', { 'for': 'rest' }
"" (La)TeX goodies
"Plug 'lervag/vimtex'
"" opinionated 'sensible' defaults for Vim
"Plug 'tpope/vim-sensible'
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
"do not use fixdel
let g:riv_disable_del = 1

"========
" Airline
"========
let g:airline_powerline_fonts = 1
let g:airline_theme='powerlineish'
" do not live-override tmux settings with airline ones
let g:airline#extensions#tmuxline#enabled = 0
" do not live-override prompt settings with airline ones
let g:airline#extensions#promptline#enabled = 0
let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#tabline#enabled = 1

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
