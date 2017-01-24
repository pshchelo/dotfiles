function! AutoCorrect()
    ia ixpe ipxe
    ia iXPE iPXE
endfunction

autocmd filetype text call AutoCorrect()
autocmd filetype rst call AutoCorrect()
