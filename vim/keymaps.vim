" turn off active search highlighting
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>

" Mapping for gracefully closing buffers with vim-bbye
:nnoremap <Leader>q :Bdelete<CR>

" Disable shortcut for entering Ex mode
nnoremap Q <nop>

" Set spellcheck toggle
nmap <Leader>s :setlocal spell! spelllang=en_us<CR>

" Toggle vertical centring of the cursor
nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>:echo "scrolloff toggled"<CR>

" Neocomplete
" <CR>: close popup
 if v:version < 800
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
      return pumvisible() ? "\<C-y>" : "\<CR>"
    endfunction
    " <TAB>: completion.
    inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
else
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
    inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
endif

" Paste mode toggle
set pastetoggle=<Leader>p

" Toggle list mode (special characters)
noremap <Leader>L :set list!<CR>

" Toggle line numbers
noremap <Leader>N :set number!<CR>

" disable arrow keys to force working with standard HJKL movement keys
"map <up> <nop>
"map <down> <nop>
"map <left> <nop>
"map <right> <nop>

" move up and down per visual line, not real line
"nnoremap j gj
"nnoremap k gk
"nnoremap <Down> gj
"nnoremap <Up> gk

" Keys to move between windows
"nmap <silent> <C-Up> :wincmd k<CR>
"nmap <silent> <C-Down> :wincmd j<CR>
"nmap <silent> <C-Left> :wincmd h<CR>
"nmap <silent> <C-Right> :wincmd l<CR>
"map <C-h> <C-w>h
"map <C-j> <C-w>j
"map <C-k> <C-w>k
"map <C-l> <C-w>l

" key map to insert pdb breakpoint if no Python-mode is present
"nnoremap <leader>b yyP^Cimport pdb; pdb.set_trace()  # XXX:breakpoint

" make vim understand commands without leaving russian keyboard layout
"set langmap=!\\"№\\;%?*ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;!@#$%&*`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>

" USEFUL UNICODE SYMBOLS
" check marks/crosses ✅ ✓ ✔ ✗ ✘ 🗴 🗶 🗸
" more ⚠ ♨ ⚡ ⌥ ⌦ ⎇ 🗲
" Powerline symbols (from private Unicode space)
"       
