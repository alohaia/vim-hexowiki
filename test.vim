" get the number of bytes of a character according to its first byte
function! s:wcharLen(charfb)
    let cmasks = [128, 224, 240, 248, 252, 254]
    let cvals  = [  0, 192, 224, 240, 248, 252]
    let char_nr = char2nr(a:charfb)
    for i in range(6)
        if and(char_nr, cmasks[i]) == cvals[i]
            return i+1
        endif
    endfor
endfunction

function! VisualInline()
    let line = getline('.')

    let vbegin = col("v") - 1
    let vend   = col(".") - 1
    if vbegin > vend
        let t = vend
        let vend = vbegin
        let vbegin = t
    endif

    " adjusts vend if it's not refering an ASCII character
    if and(char2nr(line[vend]), 128) != 0
        let vend += s:wcharLen(getline('.')[vend]) - 1
    endif

    return [getline('.')[vbegin:vend], vbegin, vend]
endfunction

function! s:wbegin(pos)
    let line = getline(a:pos[0])
    let index = a:pos[1]

    " 128：在非 ASCII 字符的内部
    " 192：在非 ASCII 字符第一个字节
    " 0 或 64：ASCII 字符
    while and(char2nr(line[index]), 192) == 128
        let index = index - 1
    endwhile
    return index
endfunction

function! s:wend(pos)
    let line = getline(a:pos[0])
    let index = a:pos[1]

    let a = and(char2nr(line[index]), 192)
    " 128：在非 ASCII 字符的内部
    " 192：在非 ASCII 字符第一个字节，继续寻找下一个第一个字节，
    "      并返回其左移一个字节的位置（index-1）
    " 0 或 64：ASCII 字符，因为之后返回的是 index-1，所以这里也向右移 1
    if a == 0 || a == 64
        return index
    elseif a == 128 || a == 192
        let index = index+1
        while and(char2nr(line[index]), 192) == 128
            let index = index + 1
        endwhile
        return index-1
    else
        echoerr 'unexpected a: ' . a
    endif
endfunction

function! WVisualSelection()
    let visual_mode = mode()

    let vbegin = [line('v'), col("v") - 1]
    let vend = [line('.'), col(".") - 1]
    if vbegin[0] > vend[0] || (vbegin[0] == vend[0] && vbegin[1] > vend[1])
        let t = vend
        let vend = vbegin
        let vbegin = t
    endif

    let selection_list = []
    if vbegin[0] == vend[0]
        call add(selection_list, getline(vbegin[0])[s:wbegin(vbegin) : s:wend(vend)])
    else
        if char2nr(visual_mode) == char2nr('v')
            call add(selection_list, getline(vbegin[0])[s:wbegin(vbegin) :])
            if vbegin[0]+1 < vend[0]
                for linenr in range(vbegin[0]+1, vend[0]-1)
                    call add(selection_list, getline(linenr))
                endfor
            endif
            call add(selection_list, getline(vend[0])[: s:wend(vend)])
        elseif char2nr(visual_mode) == char2nr('V')
            call add(selection_list, getline(vbegin[0]))
            if vbegin[0]+1 < vend[0]
                for linenr in range(vbegin[0]+1, vend[0]-1)
                    call add(selection_list, getline(linenr))
                endfor
            endif
            call add(selection_list, getline(vend[0]))
        elseif char2nr(visual_mode) == char2nr('')
            let b = min([vbegin[1], vend[1]])
            let e = max([vbegin[1], vend[1]])
            call add(selection_list, getline(vbegin[0])[s:wbegin([vbegin[0],b]) : s:wend([vbegin[0],e])])
            if vbegin[0]+1 < vend[0]
                for linenr in range(vbegin[0]+1, vend[0]-1)
                    call add(selection_list, getline(linenr)[s:wbegin([linenr,b]) : s:wend([linenr,e])])
                endfor
            endif
            call add(selection_list, getline(vend[0])[s:wbegin([vend[0],b]) : s:wend([vend[0],e])])
        endif
    endif

    return [selection_list, vbegin, vend, visual_mode]
endfunction

function! VisualSelection()
    let visual_mode = mode()

    let vbegin = [line('v'), col("v") - 1]
    let vend = [line('.'), col(".") - 1]
    if vbegin[0] > vend[0] || (vbegin[0] == vend[0] && vbegin[1] > vend[1])
        let t = vend
        let vend = vbegin
        let vbegin = t
    endif

    let selection_list = []
    if vbegin[0] == vend[0]
        call add(selection_list, getline(vbegin[0])[vbegin[1] : vend[1]])
    else
        if char2nr(visual_mode) == char2nr('v')
            call add(selection_list, getline(vbegin[0])[vbegin[1] :])
            if vbegin[0]+1 < vend[0]
                for linenr in range(vbegin[0]+1, vend[0]-1)
                    call add(selection_list, getline(linenr))
                endfor
            endif
            call add(selection_list, getline(vend[0])[: vend[1]])
        elseif char2nr(visual_mode) == char2nr('V')
            call add(selection_list, getline(vbegin[0]))
            if vbegin[0]+1 < vend[0]
                for linenr in range(vbegin[0]+1, vend[0]-1)
                    call add(selection_list, getline(linenr))
                endfor
            endif
            call add(selection_list, getline(vend[0]))
        elseif char2nr(visual_mode) == char2nr('')
            let b = min([vbegin[1], vend[1]])
            let e = max([vbegin[1], vend[1]])
            call add(selection_list, getline(vbegin[0])[[vbegin[0],b][1] : [vbegin[0],e][1]])
            if vbegin[0]+1 < vend[0]
                for linenr in range(vbegin[0]+1, vend[0]-1)
                    call add(selection_list, getline(linenr)[[linenr,b][1] : [linenr,e][1]])
                endfor
            endif
            call add(selection_list, getline(vend[0])[[vend[0],b][1] : [vend[0],e][1]])
        endif
    endif

    return [selection_list, vbegin, vend, visual_mode]
endfunction

"=========== ONLY FOR TESTING ===========

"1234567890
"2二五八22345
"1234567890
"1234567890
"2二五八22345
"1234567890

xnoremap <C-a> <Cmd>echomsg VisualSelection()<cr>
xnoremap <C-b> <Cmd>echomsg WVisualSelection()<cr>
