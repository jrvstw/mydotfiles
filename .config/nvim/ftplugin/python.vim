setlocal ts=4 sw=4 sts=0 expandtab
if has('nvim')
   "nnoremap <buffer> ;e  yy:<c-u>bp<cr>pa<cr><c-\><c-n>:<c-u>bp<cr>j
   "nnoremap <buffer> ;e  yy<c-w>ppa<cr><c-\><c-n><c-w>pj
   "vnoremap <buffer> ;e  y:<c-u>bp<cr>pa<cr><c-\><c-n>:<c-u>bp<cr>gv
    nnoremap <buffer> ;r :w !python<cr>
    vnoremap <buffer> ;r :w !python<cr>gv
    nnoremap <buffer> ;s V:w !python<cr>jV
    nnoremap <buffer> mr :<c-u>e term://python<cr>
    nnoremap <buffer> Ar :<c-u>split term://python<cr>
else
    nnoremap <buffer> Ar :<c-u>terminal python<cr><c-\><c-n>
endif

