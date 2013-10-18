" be iMproved!
set nocompatible

" do not force to save buffers when switching to new ones
set hidden

" disable auxillary files creation
set nobackup
set noswapfile

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
set hlsearch      " highlight search terms
set incsearch
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Character encoding settings
set encoding=utf-8
set fileencodings=utf-8,cp1251

" Tabulation settings
set tabstop=8
set expandtab
set softtabstop=4
set shiftwidth=4
" use multiple of shiftwidth when indenting with '<' and '>'
"set shiftround
" insert tabs on the start of a line according to shiftwidth, not tabstop
set smarttab

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
"au BufRead,BufNewFile *.py,*.pyw,*.pyx,*.c,*.h set textwidth=79

" Set interaction with system clipboard and mouse
set clipboard=unnamedplus
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
Bundle 'kien/ctrlp.vim'
Bundle 'nvie/vim-togglemouse'
"Bundle 'vim-scripts/YankRing.vim'
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
" start with all open folds
set foldlevelstart=999
set autoindent
" copy the previous indentation on autoindenting
set copyindent    

" set color scheme
if has('gui_running')
    "set background=light
    set background=dark
    colorscheme solarized
    set guifont=Anonymice\ Powerline\ 12
else
    set t_Co=16
    set background=dark
    colorscheme solarized
endif

:set guioptions-=T  "remove toolbar

" ignore these files when searching etc
set wildignore=*.swp,*.bak,*.pyc,*.class

"======================
" Initialize Powerline

set laststatus=2
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup

"======================
" Configure CtrlP fuzzy search

let g:ctrlp_cmd = 'CtrlPMixed'

"======================
" Jedi-vim configuration

" Change default binding of jedi's rename command
let g:jedi#rename_command = "<leader>rn"

"======================
" Other Python-related settings

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

" disable arrow keys to force working with standard HJKL movement keys
"map <up> <nop>
"map <down> <nop>
"map <left> <nop>
"map <right> <nop>

" move up and down per visual line, not real line
"nnoremap j gj
"nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk

" Keys to move between windows
nmap <silent> <C-Up> :wincmd k<CR>
nmap <silent> <C-Down> :wincmd j<CR>
nmap <silent> <C-Left> :wincmd h<CR>
nmap <silent> <C-Right> :wincmd l<CR>
"map <C-h> <C-w>h
"map <C-j> <C-w>j
"map <C-k> <C-w>k
"map <C-l> <C-w>l

" Switch to alternate file
nmap <C-Tab> :bnext<cr>
nmap <C-S-Tab> :bprevious<cr>

" Mapping for gracefully closing buffers with vim-bbye
:nnoremap <Leader>q :Bdelete<CR>

"=====================
" Inserting a line belllow the current line, with the same length,
" but consisting only from the char that's given after this command.
" Useful for inserting RST headers.
nmap <leader>h yypVr

"=========================

" make vim understand commands without leaving russian keyboard layout
" set langmap=ёйцукенгшщзхъфывапролджэячсмитьбю;`qwertyuiop[]asdfghjkl\;'zxcvbnm\,.;ЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>
