let g:IndentMotion_skip_comments = 0
let g:IndentMotion_always_select_appendant = 0

function! s:GetSyntaxName(line, col)
    return synIDattr(synIDtrans(synID(a:line, a:col, 1)), "name")
endfunction

function! s:Skip(line, skip_comments)
    if col([a:line, "$"]) == 1
        return 1
    elseif a:skip_comments == 1 && s:GetSyntaxName(a:line, indent(a:line) + 1) == "Comment"
        return 1
    else
        return 0
    endif
endfunction

function! s:NextStatement(line, direction, skip_comments)
    let target = a:line + a:direction
    while s:Skip(target, a:skip_comments)
        let target += a:direction
    endwhile
    return target
endfunction

" Returns the line number given the current line, direction and type.
" type:
"   1: Next equally-indented line.
"       If not found, return current position.
"
"   2: The last equally-indented line before the first less-indented one.
"       If not found, return the pointer.
"
"   3: the First less-indented line.
"       If not found, return the pointer.
function! <SID>GetLine(pos, direction, type, skip_comments)
    let indent = indent(a:pos) - ((a:type > 1) ? 1 : 0)
    let prevSt = a:pos
    let targetSt = s:NextStatement(prevSt, a:direction, a:skip_comments)
    while indent < indent(targetSt) || targetSt == prevSt
        let prevSt = targetSt
        let targetSt = s:NextStatement(prevSt, a:direction, a:skip_comments)
    endwhile
    if a:type == 1 && indent(a:pos) != indent(targetSt)
        return a:pos
    elseif a:type == 2
        return prevSt
    else
        return targetSt
    endif
endfunction

" level:
"   -1 -> the first less-indented line
"    0 -> the first equally-indented line
"   +1 -> the first further-indented line
function! s:GetLineBeta(pos, direction, indent, getPrev, skip_comments)
    "function! s:GetLineBeta(pos, direction, level, tabstop, strict, skip_comments)
    let prevSt = a:pos
    let targetSt = s:NextStatement(prevSt, a:direction, a:skip_comments)
    while a:indent < indent(targetSt) || targetSt == prevSt
        let prevSt = targetSt
        let targetSt = s:NextStatement(prevSt, a:direction, a:skip_comments)
    endwhile
    return (a:getPrev == 1)? prevSt : targetSt
endfunction

" perform a motion in n/v/o mode
function! <SID>IndentMotionGo(direction, type, prefix)
    let skip_comments = exists('g:IndentMotion_skip_comments') ? g:IndentMotion_skip_comments : 1
    let indent = (a:type > 1) ? indent(line(".")) - 1 : indent(line("."))
    let getPrev = (a:type == 2) ? 1 : 0
    let target = line(".")
    "for i in range(v:count1)
    let target = s:GetLineBeta(target, a:direction, indent, getPrev, skip_comments)
    "endfor
    return a:prefix . target . "G"
    "return a:prefix . s:GetLineBeta(line("."), a:direction, indent, getPrev, skip_comments) . "G"
    "return a:prefix . <SID>GetLine(line("."), a:direction, a:type, skip_comments) . "G"
endfunction

" perform a selection in n/v/o mode
function! <SID>IndentMotionSelect(type)
    let skip_comments = exists('g:IndentMotion_skip_comments') ? g:IndentMotion_skip_comments : 1
    let pos = line(".")
    let indent = indent(pos)
    let withOpening = (a:type == 3 && indent != 0)
    let withClosing = (withOpening == 1 && expand('%:e') != "py")
    let head = s:GetLineBeta(pos, -1, indent - 1, !withOpening, skip_comments)
    let tail = s:GetLineBeta(pos, +1, indent - 1, !withClosing, skip_comments)
    "let head = (a:type == 3 && indent != 0)
    "            \? s:GetLineBeta(pos, -1, indent - 1, 0, skip_comments)
    "            \: s:GetLineBeta(pos, -1, indent - 1, 1, skip_comments)
    "let tail = (a:type == 3 && indent != 0 && expand('%:e') != "py")
    "            \? s:GetLineBeta(pos, +1, indent - 1, 0, skip_comments)
    "            \: s:GetLineBeta(pos, +1, indent - 1, 1, skip_comments)
    execute "normal! " . tail . "GV" . head . "G"
    return
endfunction

"function! <SID>NextIndentedLine(indent, direction, toEnd)
"    let target = line(".")
"    let next = s:NextStatement(target, a:direction)
"    while a:indent < indent(next) + a:toEnd
"        let target = next
"        let next = s:NextStatement(target, a:direction)
"    endwhile
"    return (a:toEnd || a:indent != indent(next)) ? target : next
"endfunction
"
"function! <SID>NextIndentedLineForV(direction, toEnd)
"    let start = (getpos("'<")[1] == line(".")) ? getpos("'>")[1] : getpos("'<")[1]
"    normal! gv
"    return <SID>NextIndentedLine(indent(start), a:direction, a:toEnd)
"endfunction
"
"function! <SID>SelectIndent(offset)
"    let indent = indent(line("."))
"    let head = <SID>NextIndentedLine(indent, -1, 1) - a:offset
"    let tail = <SID>NextIndentedLine(indent, +1, 1)
"    if expand('%:e') != "py"
"        let tail += a:offset
"    endif
"    exe "normal! " . tail . "GV" . head . "G"
"endfunction
"
"function! <SID>TestSelect()
"    normal! o
"    let pos = line(".")
"    normal! o
"   "let pos = (line(".") == line("'>"))? line("'<") : line("'>")
"   "normal! gv
"    execute "normal! " . pos . "G"
"    return
"endfunction
"
"nnoremap    fj  :<c-u>execute s:NextIndentedLine(line("."),+1,0)<cr>
"nnoremap    FK  :<c-u>execute s:NextIndentedLine(line("."),-1,1)<cr>
"nnoremap    FJ  :<c-u>execute s:NextIndentedLine(line("."),+1,1)<cr>
"vnoremap    FK  :<c-u>execute "normal! gv" . s:NextIndentedLineForV(line("."),-1,1) . "G"<cr>
"vnoremap    FJ  :<c-u>execute "normal! gv" . s:NextIndentedLineForV(line("."),+1,1) . "G"<cr>
"nnoremap <silent> fk :call s:IndentMotionGo("up",     "n")<cr>
"nnoremap <silent> fj :call s:IndentMotionGo("down",   "n")<cr>
"nnoremap <silent> FK :call s:IndentMotionGo("top",    "n")<cr>
"nnoremap <silent> FJ :call s:IndentMotionGo("bottom", "n")<cr>
"vnoremap <silent> fk :<c-u>call s:IndentMotionGo("up", "v")<cr>
"vnoremap <silent> fj :<c-u>call s:IndentMotionGo("down", "v")<cr>
"vnoremap <silent> FK :<c-u>call s:IndentMotionGo("top", "v")<cr>
"vnoremap <silent> FJ :<c-u>call s:IndentMotionGo("bottom", "v")<cr>
"onoremap    FK  V:<c-u>execute "," . s:IndentMotionGo("top", "o")<cr>
"onoremap    FJ  V:<c-u>execute "," . s:IndentMotionGo("bottom", "o")<cr>
"nnoremap <Plug>IndentMotionTop    <Cmd>:call <SID>IndentMotionGo("top"    , "n")<cr>
"nnoremap <Plug>IndentMotionUp     <Cmd>:call <SID>IndentMotionGo("up"     , "n")<cr>
"nnoremap <Plug>IndentMotionDown   <Cmd>:call <SID>IndentMotionGo("down"   , "n")<cr>
"nnoremap <Plug>IndentMotionBottom <Cmd>:call <SID>IndentMotionGo("bottom" , "n")<cr>
"
"vnoremap <Plug>IndentMotionTop    <Cmd>:call <SID>IndentMotionGo("top"    , "v")<cr>
"vnoremap <Plug>IndentMotionUp     <Cmd>:call <SID>IndentMotionGo("up"     , "v")<cr>
"vnoremap <Plug>IndentMotionDown   <Cmd>:call <SID>IndentMotionGo("down"   , "v")<cr>
"vnoremap <Plug>IndentMotionBottom <Cmd>:call <SID>IndentMotionGo("bottom" , "v")<cr>
"noremap <expr> G <SID>TestSelect()
"noremap G :<c-u>execute "normal! " . <SID>TestSelect()<cr>
"noremap G <Cmd>:call <SID>TestSelect()<cr>

nnoremap <Plug>IndentMotionTop      :<c-u>execute "normal! " . <SID>IndentMotionGo(-1, 2, "")<cr>
vnoremap <Plug>IndentMotionTop      :<c-u>execute "normal! gv" . <SID>IndentMotionGo(-1, 2, "")<cr>
vnoremap <Plug>IndentMotionUp       :<c-u>execute "normal! gv" . <SID>IndentMotionGo(-1, 1, "")<cr>
"vnoremap <Plug>IndentMotionTop      :<c-u>execute "normal! \<esc>gv" . s:GetLineBeta(line("."), -1, 1, skip_comments) . "G"<cr>
    "return a:prefix . s:GetLineBeta(line("."), a:direction, indent, getPrev, skip_comments) . "G"

nnoremap <expr> <Plug>IndentMotionLeft   <SID>IndentMotionGo(-1, 3, "")
"nnoremap <expr> <Plug>IndentMotionTop    <SID>IndentMotionGo(-1, 2, "")
nnoremap <expr> <Plug>IndentMotionUp     <SID>IndentMotionGo(-1, 1, "")
nnoremap <expr> <Plug>IndentMotionDown   <SID>IndentMotionGo(+1, 1, "")
nnoremap <expr> <Plug>IndentMotionBottom <SID>IndentMotionGo(+1, 2, "")
vnoremap <expr> <Plug>IndentMotionLeft   <SID>IndentMotionGo(-1, 3, "")
"vnoremap <expr> <Plug>IndentMotionTop    <SID>IndentMotionGo(-1, 2, "")
"vnoremap <expr> <Plug>IndentMotionUp     <SID>IndentMotionGo(-1, 1, "")
vnoremap <expr> <Plug>IndentMotionDown   <SID>IndentMotionGo(+1, 1, "")
vnoremap <expr> <Plug>IndentMotionBottom <SID>IndentMotionGo(+1, 2, "")
onoremap <expr> <Plug>IndentMotionLeft   <SID>IndentMotionGo(-1, 3, "V")
onoremap <expr> <Plug>IndentMotionTop    <SID>IndentMotionGo(-1, 2, "V")
onoremap <expr> <Plug>IndentMotionUp     <SID>IndentMotionGo(-1, 1, "V")
onoremap <expr> <Plug>IndentMotionDown   <SID>IndentMotionGo(+1, 1, "V")
onoremap <expr> <Plug>IndentMotionBottom <SID>IndentMotionGo(+1, 2, "V")
vnoremap <Plug>IndentMotionInner :<c-u>call <SID>IndentMotionSelect(2)<cr>
vnoremap <Plug>IndentMotionAll   :<c-u>call <SID>IndentMotionSelect(3)<cr>
onoremap <Plug>IndentMotionInner :<c-u>call <SID>IndentMotionSelect(2)<cr>
onoremap <Plug>IndentMotionAll   :<c-u>call <SID>IndentMotionSelect(3)<cr>

