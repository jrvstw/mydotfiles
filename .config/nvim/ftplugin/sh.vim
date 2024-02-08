setlocal ts=4 sw=4 sts=0 expandtab
if has('nvim')
    nnoremap <buffer> ;e  yy:<c-u>bp<cr>pa<cr><c-\><c-n>:<c-u>bp<cr>j
    vnoremap <buffer> ;e  y:<c-u>bp<cr>pa<cr><c-\><c-n>:<c-u>bp<cr>gv
endif
