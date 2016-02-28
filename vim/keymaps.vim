" turn off active search highlighting
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
"
" Switch to alternate file
nmap <F9> :bnext<cr>
nmap <F8> :bprevious<cr>

" Mapping for gracefully closing buffers with vim-bbye
:nnoremap <Leader>q :Bdelete<CR>

" Disable shortcut for entering Ex mode
nnoremap Q <nop>

" Set shorcut to toggle PASTE mode
nmap <leader>p :set paste!<CR>

" Set spellcheck toggle
imap <Leader>s <C-o>:setlocal spell! spelllang=en_us<CR>
nmap <Leader>s :setlocal spell! spelllang=en_us<CR>

" Toggle vertical centring of the cursor
nnoremap <Leader>zz :let &scrolloff=999-&scrolloff<CR>:echo "scrolloff toggled"<CR>

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
"nnoremap <leader>b yyP^Cimport pdb; pdb.set_trace()  # XXX:breakpoint

" make vim understand commands without leaving russian keyboard layout
"set langmap=!\\"№\\;%?*ёйцукенгшщзхъфывапролджэячсмитьбюЁЙЦУКЕHГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;!@#$%&*`qwertyuiop[]asdfghjkl\\;'zxcvbnm\\,.~QWERTYUIOP{}ASDFGHJKL:\\"ZXCVBNM<>

" USEFUL UNICODE SYMBOLS
" check marks/crosses ✅ ✓ ✔ ✗ ✘ 🗴 🗶 🗸
" more ⚠ ♨ ⚡ ⌥ ⌦ ⎇ 🗲
" Powerline symbols (from private Unicode space) 
"       
