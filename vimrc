" be iMproved!
set nocompatible

" Find what OS being run under
if has ("win32") || has("win64") || has("win16") || has("win95")
    let osname="win"
else
    let osname="other"
endif

" Default Windows customizations
if osname is "win"
    source $VIMRUNTIME/vimrc_example.vim
    " source $VIMRUNTIME/mswin.vim
    " behave mswin

    set diffexpr=MyDiff()
    function MyDiff()
      let opt = '-a --binary '
      if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
      if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
      let arg1 = v:fname_in
      if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
      let arg2 = v:fname_new
      if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
      let arg3 = v:fname_out
      if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
      let eq = ''
      if $VIMRUNTIME =~ ' '
        if &sh =~ '\<cmd'
          let cmd = '""' . $VIMRUNTIME . '\diff"'
          let eq = '"'
        else
          let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
        endif
      else
        let cmd = $VIMRUNTIME . '\diff'
      endif
      silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

" Character encoding settings
set encoding=utf-8
set fileencodings=utf-8,cp1251

" Tabulation settings
set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4
" Show colored border column
set colorcolumn=80
" Show line numbers
set number
" Diff shows vertical split by default
set diffopt+=vertical
" Autoremove trailing whitespace in Python files
autocmd FileType python autocmd BufWritePre <buffer> :%s/\s\+$//e

" alter tab settings for C files according to Python/C suggestions
fu Select_c_style()
    if search('^\t', 'n', 150)

        set shiftwidth=8
        set noexpandtab
    el 
        set shiftwidth=4
        set expandtab
    en
endf
au BufRead,BufNewFile *.c,*.h call Select_c_style()
au BufRead,BufNewFile Makefile* set noexpandtab

" Use the below highlight group when displaying bad whitespace is desired.
highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw,*.pyx match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw*,.pyx,*.c,*.h match BadWhitespace /\s\+$/

" Wrap text after a certain number of characters
" Python: 79 
" C: 79
au BufRead,BufNewFile *.py,*.pyw,*.pyx,*.c,*.h set textwidth=79

" Set interaction with system clipboard and mouse
if osname is "win"
    set clipboard=unnamed
else
    set clipboard=unnamedplus
endif
set mouse=a

" required for Vundle
filetype off                   
" Vundle initialization
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" Use Vundle
Bundle 'gmarik/vundle'

" My other Bundles
Bundle 'moll/vim-bbye'
Bundle 'tpope/vim-fugitive'
"Bundle 'tpope/vim-sensible'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'altercation/vim-colors-solarized'
Bundle 'ervandew/supertab'
Bundle 'majutsushi/tagbar'
"Bundle 'klen/python-mode'
Bundle 'davidhalter/jedi-vim'
Bundle 'Rykka/riv.vim'
Bundle 'Lokaltog/vim-powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'jmcantrell/vim-virtualenv'
"Bundle 'garbas/vim-snipmate'
" needed by vim-snipmate
"Bundle 'tomtom/tlib_vim'
"Bundle 'MarcWeber/vim-addon-mw-utils'

syntax on
filetype plugin indent on

" Higllight, indent and folding settings
let python_highlight_all=1
filetype indent on
filetype plugin on
set foldmethod=indent
set foldlevelstart=999
set autoindent
" Needed for Powerline
set laststatus=2

" set color scheme
if has('gui_running')
    "set background=light
    set background=dark
    colorscheme solarized
    if has("gui_gtk2")
        set guifont=Anonymice\ Powerline\ 12
    elseif has("gui_win32")
        set guifont=Anonymous_Pro:h12:cRUSSIAN
    endif
else
    set t_Co=16
    set background=dark
    colorscheme solarized
endif

:set guioptions-=T  "remove toolbar

" Initialize Powerline
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

"======================
" Jedi-vim configuration

" Change default binding of jedi's rename command
let g:jedi#rename_command = "<leader>rn"

" Disable doctext from popping while autocompleting
"autocmd FileType python setlocal completeopt-=preview

"======================
" Other Python-related settings

" Add the virtualenv's site-packages to vim path
"py << EOF
"import os.path
"import sys
"import vim
"if 'VIRTUAL_ENV' in os.environ:
    "project_base_dir = os.environ['VIRTUAL_ENV']
    "sys.path.insert(0, project_base_dir)
    "activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    "execfile(activate_this, dict(__file__=activate_this))
"EOF

" key map to insert ipdb breakpoint
nnoremap <leader>b yyP^Cimport ipdb; ipdb.set_trace()  # XXX:breakpoint

" key map to insert pdb breakpoint
"nnoremap <leader>b yyP^Cimport pdb; pdb.set_trace()  # XXX:breakpoint

"=========================
" Syntastic configuration

" Define nice error symbols
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

" Allways stick found errors to loclist
let g:syntastic_always_populate_loc_list=1

" Aggregate errors from all checkers
let g:syntastic_aggregate_errors=1

" Automatically closa and open loclist
let g:syntastic_auto_loc_list=1

" Use Pylama as a sole checker for Python files
" Available are pep8,pep257,pyflakes,pylint,py3kwarn,python,flake8,pylama
let g:syntastic_python_checkers = ['pylama']
" Select which checkers Pylama runs
" Available are pep8,pep257,pyflakes,pylint,mccabe
let g:syntastic_python_pylama_args = '-l pep8,pyflakes'

"=========================
" NERDTree configuration

" filter on *.pyc files in NERDTree plugin
let NERDTreeIgnore = ['\.pyc$']

" Key to toggle NERDTree sidebar
map <F3> :NERDTreeToggle<CR>

"=========================
" Tagbar configuration
let g:tagbar_width = 32

" Key to toggle TagBar sidebar
nmap <F4> :TagbarToggle<CR>

"=========================
" Working with buffers and windows

" Keys to move between split windows
nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

" Switch to alternate file
map <C-Tab> :bnext<cr>
map <C-S-Tab> :bprevious<cr>

" Mapping for gracefully closing buffers with vim-bbye
:nnoremap <Leader>q :Bdelete<CR>

"=====================
" Inserting a line belllow the current line, with the same length,
" but consisting only from the char that's given after this command.
" Useful for inserting RST headers.
nmap <leader>h yypVr

"=====================
" Python mode settings
"---------------------
" Load the whole python-mode
"let g:pymode = 1

" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator modes)
" ]]            Jump on next class or function (normal, visual, operator modes)
" [M            Jump on previous class or method (normal, visual, operator modes)
" ]M            Jump on next class or method (normal, visual, operator modes)
"let g:pymode_rope = 0 

" Documentation
"let g:pymode_doc = 0
"let g:pymode_doc_key = 'K'

"Linting
"let g:pymode_lint = 1
"let g:pymode_lint_checker = "pyflakes,pep8"
" Auto check on save
"let g:pymode_lint_write = 1

" Support virtualenv
"let g:pymode_virtualenv = 1

" Enable breakpoints plugin
"let g:pymode_breakpoint = 1
"let g:pymode_breakpoint_key = '<leader>b'

" syntax highlighting
"let g:pymode_syntax = 1
"let g:pymode_syntax_all = 1
"let g:pymode_syntax_indent_errors = g:pymode_syntax_all
"let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
"let g:pymode_folding = 0

" Load run code plugin
"let g:pymode_run = 1

" Key for run python code
"let g:pymode_run_key = '<leader>r'

"=========================

" make vim understand commands without leaving russian keyboard layout
" set langmap=ёйцукенгшщзхъфывапролджэячсмитьбю;`qwertyuiop[]asdfghjkl\;'zxcvbnm\,.;ЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>
