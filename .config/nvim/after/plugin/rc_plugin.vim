" Bclose {{{
if exists('g:loaded_bclose')
    nnoremap qf :<c-u>Bclose<cr>
endif
" }}}

" EasyMotion {{{
let g:EasyMotion_do_mapping = 0
if exists('g:EasyMotion_loaded')
    let g:EasyMotion_smartcase = 1
    map   . <Plug>(easymotion-bd-f)
    nmap  . <Plug>(easymotion-overwin-f)
    map   / <Plug>(easymotion-sn)
    omap  / <Plug>(easymotion-tn)
endif
" }}}

" Tagbar {{{
if exists('g:tagbar_width')
   "let g:tagbar_left=1
    let g:tagbar_width=27
   "let g:tagbar_autofocus=1
   "let g:tagbar_autoclose=1
    let g:tagbar_sort = 0
    noremap td :<c-u>TagbarToggle<CR>
    noremap md :<c-u>TagbarOpenAutoClose<cr>
endif
" }}}

" FZF {{{
if exists('g:loaded_fzf')
    nnoremap mb         :<c-u>Marks<cr>
    nnoremap f/f        :<c-u>BLines<cr>
    nnoremap f/o        :<c-u>Lines<cr>
    nnoremap f/d        :<c-u>Rg<cr>
    nnoremap F?f        :<c-u>BLines <c-r><c-w><cr>
    nnoremap F?o        :<c-u>Lines '<c-r><c-w><cr>
    nnoremap F?d        :<c-u>Rg <c-r><c-w><cr>
    nnoremap mfd        :<c-u>Files<cr>
    nnoremap mfr        :<c-u>History<cr>
    nnoremap mfo        :<c-u>Buffers<cr>
    nnoremap gw         :<c-u>Windows<cr>
    nnoremap sc         :<c-u>Commands<cr>
    nnoremap sh         :<c-u>Helptags<cr>
    nnoremap s:         :<c-u>History:<cr>
    nnoremap s/         :<c-u>History/<cr>

    if has('nvim')
        "let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"
        let $FZF_DEFAULT_OPTS=' --color=dark --margin=1,2 --layout=reverse --preview-window=hidden'
        let g:fzf_layout = { 'window': 'call FloatingFZF()' }
        function! FloatingFZF()
            let buf = nvim_create_buf(v:false, v:true)
            call setbufvar(buf, '&signcolumn', 'no')
            let height = (&lines > 40)? float2nr(24): float2nr(&lines * 0.6)
            let width = (&columns > 150)? float2nr(120): float2nr(&columns * 0.8)
            let vertical = float2nr((&lines - height) / 4)
            let horizontal = float2nr((&columns - width) / 2)
            let opts = {
                \ 'relative': 'editor',
                \ 'row': vertical,
                \ 'col': horizontal,
                \ 'width': width,
                \ 'height': height
                \ }

          call nvim_open_win(buf, v:true, opts)
        endfunction
    else
        let $FZF_DEFAULT_OPTS=' --color=dark --layout=reverse'
        autocmd! FileType fzf
        autocmd  FileType fzf set laststatus=0 noshowmode noruler
                    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
    endif

    let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-h': 'split',
      \ 'ctrl-v': 'vsplit',
      \ 'ctrl-b': 'bdelete' }

    let g:fzf_colors = {
      \ 'fg':           ['fg', 'Comment'],
      \ 'bg':           ['bg', 'Pmenu', 'Normal'],
      \ 'preview-fg':   ['fg', 'Normal'],
      \ 'preview-bg':   ['bg', 'Normal'],
      \ 'hl':           ['fg', 'String', 'Comment'],
      \ 'fg+':          ['fg', 'Pmenu'],
      \ 'bg+':          ['bg', 'Pmenu', 'CursorColumn', 'Normal'],
      \ 'gutter':       ['bg', 'Pmenu'],
      \ 'hl+':          ['fg', 'String', 'Statement'],
      \ 'info':         ['fg', 'Number'],
      \ 'border':       ['bg', 'Normal'],
      \ 'prompt':       ['fg', 'Statement'],
      \ 'pointer':      ['fg', 'Statement'],
      \ 'marker':       ['fg', 'Function'],
      \ 'spinner':      ['fg', 'Number'],
      \ 'header':       ['fg', 'PreProc'] }

endif
" }}}

" GitGutter {{{
if exists("g:loaded_gitgutter")
    nmap sg <esc><Plug>(GitGutterPreviewHunk)
endif
" }}}

" Vim-Trailing-Whitespace {{{
if exists("g:loaded_trailing_whitespace_plugin")
    hi! link ExtraWhitespace visual
    autocmd ColorScheme * hi! link ExtraWhitespace visual
endif
" }}}

" Ranger {{{
if &rtp =~ 'ranger.vim'
    let g:ranger_mak_keys = 0
    noremap se  :<c-u>RangerWorkingDirectory<cr>
    noremap sE  :<c-u>RangerCurrentFile<cr>
    noremap Ae  :<c-u>RangerWorkingDirectoryNewTab<cr>
    noremap AE  :<c-u>RangerCurrentFileNewTab<cr>
endif
" }}}

" IndentLine {{{
let g:indentLine_enabled = 0
noremap ti :<c-u>IndentLinesToggle<cr>
" }}}

" IndentMotion {{{
if exists('g:IndentMotion_skip_comments')
    map     fk  <Plug>IndentMotionTop
    map     fj  <Plug>IndentMotionBottom
    map     K   <Plug>IndentMotionUp
    map     J   <Plug>IndentMotionDown
   "map     H   <Plug>IndentMotionLeft
    map     L   <Plug>IndentMotionRight
    vmap    ii  <Plug>IndentMotionInner
    vmap    oi  <Plug>IndentMotionAll
    omap    ii  <Plug>IndentMotionInner
    omap    oi  <Plug>IndentMotionAll
endif
" }}}

" --------------------------------
" vim:foldmethod=marker:foldlevel=99
