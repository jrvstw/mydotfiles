"" Install Vundle
let iCanHazVundle=1
"if has('unix')
    let vundle_readme=expand('$HOME/.config/nvim/bundle/Vundle.vim/README.md')
    if !filereadable(vundle_readme)
        echo "Installing Vundle.."
        echo ""
        silent !mkdir -p ~/.config/nvim/bundle
        silent !git clone https://github.com/gmarik/vundle $HOME/.config/nvim/bundle/Vundle.vim
    endif
"endif
let iCanHazVundle=0

set nocompatible              " be iMproved, required
filetype off                  " required
set runtimepath+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'junegunn/fzf.vim'
    Plugin 'francoiscabrol/ranger.vim'
   "Plugin 'rafaqz/ranger.vim'
    Plugin 'easymotion/vim-easymotion'
    Plugin 'tpope/vim-surround'
    Plugin 'bronson/vim-trailing-whitespace'
    Plugin 'majutsushi/tagbar'
    Plugin 'airblade/vim-gitgutter'
    Plugin 'JuliaEditorSupport/julia-vim'
    Plugin 'yggdroot/indentLine'
    Plugin 'rbgrouleff/bclose.vim'
    Plugin 'arcticicestudio/nord-vim'
   "Plugin 'morhetz/gruvbox'
   "Plugin 'altercation/vim-colors-solarized'
   "Plugin 'mhinz/vim-startify'
   "Plugin 'kana/vim-submode'
   "Plugin 'Yggdroot/LeaderF'
   "Plugin 'pseewald/vim-anyfold'
   "Plugin 'mileszs/ack.vim'
   "Plugin 'sjl/gundo.vim'
call vundle#end()            " required
filetype plugin indent on    " required

" Filetype & Format {{{

    filetype plugin on
    set encoding=utf-8
    set fileencodings=utf-8,default,big5,latin1

    set tabstop=4 shiftwidth=4 softtabstop=4 expandtab
    set autoindent smartindent smarttab

" }}}
" Layout {{{

    " Line Number {{{
       "set numberwidth=4
        set number
        set norelativenumber
    " }}}
    " Cursor Line/Column {{{
        set cursorline nocursorcolumn
        autocmd WinEnter,BufEnter,FocusGained * set cul
        autocmd WinLeave,BufLeave,FocusLost * set nocul
    " }}}
    " StatusLine {{{
        set laststatus=2
        set statusline=[%{&ff},%{&fenc?&fenc:&enc}%Y]
        set statusline+=\ %<%F%m
        set statusline+=%=
        set statusline+=%-16(%4p%%\ (%l,%v)%)
       "set statusline+=%b\ 0x%B
        set wildmenu
        set wildignore=*.o,*.exe,*.out
    " }}}
    " Folding {{{

        set foldenable
        set foldlevel=99
        set foldmethod=syntax
       "set fillchars="vert:\|,fold:\u0020"

        function! MyFoldText()
            return getline(v:foldstart)
           "let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
           "let lines_count = v:foldend - v:foldstart + 1
           "let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
           "let foldchar = matchstr(&fillchars, 'fold:\zs.')
           "let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
           "let foldtextend = lines_count_text . repeat(foldchar, 8)
           "let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
           "return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
        endfunction
        set foldtext=MyFoldText()

    " }}}
    " Netrw {{{
        let g:netrw_banner=0
       "let g:netrw_browse_split=4
       "let g:netrw_altv=1
        let g:netrw_liststyle=3
    " }}}

    function! ReviseColorScheme()
        hi! link Folded Comment
    endfunction
   "autocmd ColorScheme * call ReviseColorScheme()
    autocmd ColorScheme * hi! link Folded Comment
    autocmd InsertEnter * hi CursorLine guibg=#21262E
    autocmd InsertLeave * hi CursorLine guibg=#3B4252

    set background=dark
    set termguicolors
    colorscheme nord

    set guioptions=aegit
    set guifont=Monospace\ 12
    set nowrap
    set scrolloff=996
    set showcmd
    syntax enable
    set listchars=tab:\|\ ,nbsp:+  ",trail:-
    set nolist
    set splitbelow
    set splitright

" }}}

" Interaction Control {{{

    " vimdiff {{{
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
            if $VIMRUNTIME =~ ' '
                if &sh =~ '\<cmd'
                    if empty(&shellxquote)
                        let l:shxq_sav = ''
                        set shellxquote&
                    endif
                    let cmd = '"' . $VIMRUNTIME . '\diff"'
                else
                    let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
                endif
            else
                let cmd = $VIMRUNTIME . '\diff'
            endif
            silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
            if exists('l:shxq_sav')
                let &shellxquote=l:shxq_sav
            endif
        endfunction
    " }}}
    " Functions for mapping {{{
    " }}}
    " Key Mapping {{{

        let mapleader = "\\"
        let maplocalleader = "|"

    "" free
        noremap <c-q> <nop>
        noremap <c-s> <nop>
        noremap <c-d> <nop>
        noremap A     <nop>
        noremap a     <nop>
        noremap F     <nop>
        noremap f     <nop>
        noremap G     <nop>
        noremap g     <nop>
        noremap J     <nop>
        noremap m     <nop>
        noremap mf    <nop>
        noremap mS    <nop>
        noremap ms    <nop>
       vnoremap o     <nop>
        noremap Q     <nop>
        noremap q     <nop>
        noremap S     <nop>
        noremap Sp    <nop>
        noremap Ss    <nop>
        noremap s     <nop>
        noremap T     <nop>
        noremap t     <nop>
        noremap X     <nop>
        noremap x     <nop>
        noremap Z     <nop>
        noremap z     <nop>
        noremap ,     <nop>
        noremap .     <nop>
        noremap ;     <nop>
        noremap '     <nop>
        noremap `     <nop>



    "" mode
        nnoremap i i
        nnoremap o a
        nnoremap I I
        nnoremap O A
        nnoremap fi O
        nnoremap fo o
       "nnoremap c c
       "vnoremap c c
       "nnoremap cc cc
       "nnoremap C C
       "vnoremap C C

       "noremap v v
       "noremap V V
        noremap fv <c-v>
        nnoremap R gR
       "noremap : :

        inoremap <esc> <esc>`^


    "" move cursor
        "" by column
           "noremap h h
           "noremap l l
            noremap mc \|
            noremap fh ^
            noremap fl $

        "" by line
            noremap k   gk
            noremap j   gj
            noremap ml  gg
            noremap mL  G
           "map     fk  <Plug>IndentMotionTop
           "map     fj  <Plug>IndentMotionBottom
           "map     K   <Plug>IndentMotionUp
           "map     J   <Plug>IndentMotionDown
           "map     H   <Plug>IndentMotionLeft
           "map     L   <Plug>IndentMotionRight

        "" by word
            noremap W b
           "noremap w w
            noremap E ge
           "noremap e e
            noremap FW B
            noremap fw W
            noremap FE gE
            noremap fe E

        "" by sentence
            noremap FB (
            noremap fb )

        "" by paragraph
            noremap B {
            noremap b }

        "" by syntax
            map  ma %

        "" among history
            nnoremap M <c-o>
            nnoremap mm <c-i>
            nnoremap fm ``

        "" among quickfix list
            nnoremap mQ :<c-u>cp<cr>
            nnoremap mq :<c-u>cn<cr>

        "" to character
            noremap <  F
            noremap F< T
            noremap F> t
            noremap >  f
            noremap FN ,
            noremap fn ;
           "map     .  <Plug>(easymotion-bd-f)
           "nmap    .  <Plug>(easymotion-overwin-f)

        "" to string
            nnoremap <expr> ? &hlsearch ? ':<c-u>set nohlsearch<cr>' : '#*:<c-u>set hlsearch<cr>'
           "noremap N N
           "noremap n n
           "map        / <Plug>(easymotion-sn)
           "omap       / <Plug>(easymotion-tn)
           "nnoremap f/f :<c-u>BLines<cr>
           "nnoremap f/o :<c-u>Lines<cr>
           "nnoremap f/d :<c-u>Rg<cr>
           "nnoremap F?f :<c-u>BLines '<c-r><c-w><cr>
           "nnoremap F?o :<c-u>Lines <c-r><c-w><cr>
           "nnoremap F?d :<c-u>Ag <c-r><c-w><cr>

        "" to definition
           "nnoremap md esc>:TagbarOpenAutoClose<cr>
            nnoremap mD gd

        "" to file
           "nnoremap mfo :<c-u>Buffers<cr>
            nnoremap mfp :<c-u>bp<cr>
           "nnoremap mfd :<c-u>Files<cr>
           "nnoremap mfr :<c-u>History<cr>
            nnoremap mF gf
            nnoremap m, :<c-u>e $MYVIMRC<cr>

        "" to external program
            if has('nvim')
                nnoremap m. :<c-u>e term://$SHELL<cr>
            endif

        "" to mark
            noremap mb `
            noremap sb m
           "nnoremap mb :<c-u>Marks<cr>

        nnoremap mi `^
        vnoremap mo o
        nnoremap mT <c-]>
        nnoremap mv gv


    "" edit
        "" register
           "nnoremap d d
           "vnoremap d d
           "nnoremap D D
           "vnoremap D D
           "nnoremap dd dd
           "nnoremap y y
           "vnoremap y y
            nnoremap Y y$
           "vnoremap Y Y
           "nnoremap yy yy
           "nnoremap P P
           "vnoremap P P
           "nnoremap p p
           "vnoremap p p
            nnoremap FP ]P
            nnoremap fp ]p
            nnoremap r gr
            vnoremap r gr
           "nnoremap " "
           "nnoremap "" ""
            nnoremap S" q
            nnoremap '  @
            nnoremap '' @@

        "" history
           "nnoremap u u
            nnoremap U <c-r>
            nnoremap fu g-
            nnoremap FU g+
            nnoremap X .

        "" auto completion
           "inoremap <c-p> <c-p>
           "inoremap <c-n> <c-n>

        "" parenthesis
           "nnoremap ys ys
           "nnoremap cs cs
           "nnoremap ds ds
           "vnoremap S  S

        "" indentation
           "inoremap <c-d> <c-d>
           "inoremap <c-t> <c-t>
            nnoremap x, <<
            nnoremap x. >>
            nnoremap x= ==
            vnoremap x, <gv
            vnoremap x. >gv
            vnoremap x= =gv

        "" case
            nnoremap xc ~
            vnoremap xc ~
            nnoremap xu gU
            nnoremap xu U
            nnoremap xl gu
            nnoremap xl u

        "" value
            nnoremap x+ <c-a>
            vnoremap x+ <c-a>
            nnoremap x- <c-x>
            vnoremap x- <c-x>

        nnoremap xj J
        vnoremap xj J
        nnoremap xJ gJ
        vnoremap xJ gJ
       "inoremap <c-v> <c-v>
       "inoremap <c-o> <c-o>
       "inoremap <c-r> <c-r>


    "" visual select
       "vnoremap iw iw
        vnoremap ifw iW
        vnoremap ifb is
       "vnoremap ip ip
        vnoremap ib ip
       "vnoremap it it
       "vnoremap i( i(
       "vnoremap i) i)
       "vnoremap i[ i[
       "vnoremap i] i]
       "vnoremap i{ i{
       "vnoremap i} i}
       "vnoremap i< i<
       "vnoremap i> i>
       "vnoremap i' i'
       "vnoremap i" i"
        vnoremap ow aw
        vnoremap ofw aW
        vnoremap ofb as
        vnoremap op ap
        vnoremap ob ap
        vmap     ot at
        vnoremap o( a(
        vnoremap o) a)
        vnoremap o[ a[
        vnoremap o] a]
        vnoremap o{ a{
        vnoremap o} a}
        vnoremap o< a<
        vnoremap o> a>
        vnoremap o' a'
        vnoremap o" a"
       "vmap     ii <Plug>IndentMotionInner
       "vmap     oi <Plug>IndentMotionAll

       "onoremap iw iw
        onoremap ifw iW
        onoremap ifb is
       "onoremap ip ip
        onoremap ib ip
       "onoremap it it
       "onoremap i( i(
       "onoremap i) i)
       "onoremap i[ i[
       "onoremap i] i]
       "onoremap i{ i{
       "onoremap i} i}
       "onoremap i< i<
       "onoremap i> i>
       "onoremap i' i'
       "onoremap i" i"
        onoremap ow aw
        onoremap ofw aW
        onoremap ofb as
        onoremap op ap
        onoremap ob ap
        omap     ot at
        onoremap o( a(
        onoremap o) a)
        onoremap o[ a[
        onoremap o] a]
        onoremap o{ a{
        onoremap o} a}
        onoremap o< a<
        onoremap o> a>
        onoremap o' a'
        onoremap o" a"
       "omap     ii <Plug>IndentMotionInner
       "omap     oi <Plug>IndentMotionAll

       "vnoremap I I
        vnoremap O A


    "" view
        "" scroll
            noremap <c-k> <c-e>
            noremap <c-j> <c-y>
            noremap <c-o> <c-d>
           "noremap <c-u> <c-u>
            noremap <c-r> zz
            noremap <c-h> 2zl
            noremap <c-l> 2zh

        "" folding
            nnoremap - zc
            nnoremap = zo
            nnoremap _ zm
            nnoremap + zr
            nnoremap f- zC
            nnoremap f= zO
            nnoremap f_ zM
            nnoremap f+ zR


    "" system
        "" buffers, windows, tabs
            nnoremap SF  :<c-u>w<cr>
            nnoremap Sa  :<c-u>wa<cr>
            nnoremap QF  :<c-u>bp\|bd #<cr>
           "nnoremap QF  :<c-u>Bclose<cr>
            nnoremap Qa  :<c-u>qa<cr>
           "nnoremap sqf :<c-u>wq<cr>
           "nnoremap sqa :<c-u>wqa<cr>
            nnoremap fQ  :<c-u>bd!<cr>

            nnoremap Aw  <c-w>n
            nnoremap At  :<c-u>tabe<cr>
            nnoremap AW  <c-w>s
            nnoremap AT  <c-w>s<c-w>T
            nnoremap A,  :<c-u>tabe $MYVIMRC<cr>
            if has('nvim')
                nnoremap A.  :<c-u>split term://$SHELL<cr>
            else
                nnoremap A.  :<c-u>terminal<cr><c-\><c-n>
            endif
           "nnoremap Ae  :<c-u>RangerWorkingDirectory<cr>
           "nnoremap AE  :<c-u>RangerCurrentFile<cr>

            nnoremap QW :<c-u>q<cr>
            nnoremap QT :<c-u>tabc<cr>
            nnoremap Qo <c-w>o

            nnoremap SS :<c-u>mksession!<cr>
            nnoremap AS :<c-u>source Session.vim<cr>

        "" align windows and tabs
            nnoremap ak <c-w>K
            nnoremap aj <c-w>J
            nnoremap ah <c-w>H
            nnoremap al <c-w>L
            nnoremap at <c-w>T
            nnoremap ai :<c-u>-tabm<cr>
            nnoremap ao :<c-u>+tabm<cr>

            nnoremap aw  <c-w>-
            nnoremap as  <c-w>+
            nnoremap aS  <c-w>_
            nnoremap aa  <c-w><
            nnoremap ad  <c-w>>
            nnoremap aD  <c-w>\|
            nnoremap ae  <c-w>=

        "" go to another window
            nnoremap gk <c-w>k
            nnoremap gj <c-w>j
            nnoremap gh <c-w>h
            nnoremap gl <c-w>l
            nnoremap gi gT
            nnoremap go gt
            nnoremap gw :<c-u>Windows<cr>
            nnoremap G  <c-w>p

        "" toggle
            nnoremap tc  :<c-u>set cursorcolumn!<cr>
           "nnoremap td  :<c-u>TagbarToggle<CR>
            nnoremap th  :<c-u>set hlsearch!<cr>
           "nnoremap ti  :<c-u>IndentLinesToggle<cr>
            nnoremap tm  :<c-u>let &scrolloff=999-&scrolloff<cr>
            nnoremap tr  :<c-u>set rnu!<cr>
            nnoremap tw  :<c-u>set wrap!<cr>
            nnoremap t\  :<c-u>set list!<cr>

        "" show
            nnoremap sa ga
            nnoremap sb :<c-u>marks<cr>
            nnoremap sc :<c-u>command<cr>
           "nnoremap sc :<c-u>Commands<cr>
            nnoremap sd :<c-u>pwd<cr>
           "nnoremap se  :<c-u>RangerWorkingDirectory<cr>
           "nnoremap sE  :<c-u>RangerCurrentFile<cr>
           "nmap     sg <Plug>(GitGutterPreviewHunk)
           "nnoremap sh :<c-u>Helptags<cr>
            nnoremap sK K
            nnoremap sm :<c-u>jumps<cr>
            nnoremap so :<c-u>files<cr>
            nnoremap sq :<c-u>cl<cr>
            nnoremap ss :<c-u>echom synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")<cr>
            nnoremap su :<c-u>undol<cr>
            nnoremap s: :<c-u>history:<cr>
           "nnoremap s: :<c-u>History:<cr>
            nnoremap s" :<c-u>reg<cr>
            nnoremap s/ :<c-u>history/<cr>
           "nnoremap s/ :<c-u>History/<cr>

        nnoremap ;n :<c-u>normal! 
        nnoremap ;h :<c-u>help 
        nnoremap ;m :<c-u>map 
        nnoremap ;/ /


    "" for navigation keys
        noremap <up>    <C-y>
        noremap <down>  <C-e>
        noremap <left>  2zh
        noremap <right> 2zl
        noremap <home>  gg
        noremap <end>   G

        noremap <c-PageUp> gT
        noremap <c-PageDown> gt
        noremap <c-s-PageUp> :-tabm<cr>
        noremap <c-s-PageDown> :+tabm<cr>


    " }}}

    let g:ranger_command_override = 'ranger --cmd="chain map <esc> quit; set draw_borders border; set column_ratios 0,5,3"'

    set autowrite               " writes file when make
    set hidden                  " keep undo history when switching buffers
    set timeoutlen=3000         " used for mapping delays
    set ttimeoutlen=10          " used for keycode delays
    set updatetime=500
    set history=200
    set lazyredraw
    set visualbell
    set showmatch
   "set matchtime=2
    set nohlsearch
    set mouse=
   "if has('reltime')           " real-time search
   "    set incsearch
   "endif

" }}}


" --------------------------------
" vim:foldmethod=marker:foldlevel=99
