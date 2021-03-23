"---------------------------------------\ config /---------------------------------------
let g:hexowiki_skeleton = {
            \ 'post': '~/aloha.github.io/scaffolds/post.md',
            \ 'page': '~/aloha.github.io/scaffolds/page.md',
            \ 'draft': '~/aloha.github.io/scaffolds/draft.md'
            \ }

let g:hexowiki_home = '~/aloha.github.io/source/_posts/'
let g:hexowiki_follow_after_create = 0

function! s:if_at_home()
    return expand('%:p:h') == expand(g:hexowiki_home) || expand('%:p:h') == expand(g:hexowiki_home)[:-2]
endfunction


"---------------------------------------\ plugin /---------------------------------------
if exists('g:hexowiki_loaded') || &compatible
  finish
endif
let g:hexowiki_loaded = 1

"---------------------------------\ initialize a file /----------------------------------
function! s:init_file() abort
    " TODO: detect page type
    let l:type = 'post'

    call system('hexo new ' . l:type . ' ' . expand('%:t:r'))
    edit
endfunction

augroup hexowiki
    au!
    autocmd BufNewFile *.md if s:if_at_home() | call s:init_file() | endif
augroup END

function! s:is_ascii(pos)
    let line = getline('.')
    if and(char2nr(line[col(a:pos)-1]), 128) == 0
        return v:true
    else
        return v:false
    endif
endfunction

" get the number of bytes of a character according to its first byte
function! g:Wchar_len(charfb)
    let cmasks = [128, 224, 240, 248, 252, 254]
    let cvals  = [  0, 192, 224, 240, 248, 252]
    let char_nr = char2nr(a:charfb)
    for i in range(6)
        if and(char_nr, cmasks[i]) == cvals[i]
            return i+1
        endif
    endfor
endfunction

function! g:Visual_inline()
    let vbegin = col("'<") - 1
    let vend   = col("'>") - 1
    if s:is_ascii("'>") != v:true
        let vend += g:Wchar_len(getline('.')[vend]) - 1
    endif
    return [getline('.')[vbegin:vend], vbegin, vend]
endfunction

xnoremap <C-a> :<C-u>echomsg Visual_inline()<CR>

" Create a new link under the cursor
"
" Return:
"   - Empty string if failed.
"   - Name of new file if Succeed.
function! g:Create_link(mode)
    let line = getline('.')
    let col = col('.') - 1

    if char2nr(line[col]) == 32 || char2nr(line[col]) == 9 || char2nr(line[col]) == 0
        echo 'Not on any valid text'
        return ''
    endif

    if a:mode == 'v' || a:mode == 'V'
        " Visual mode
        let visual_selection = Visual_inline()
        let base = visual_selection[0]
        echo visual_selection
        if visual_selection[1] == 0
            let newline = '{% post_link ' . substitute(visual_selection[0], '\s', '-', 'g') .
                        \ ' "' . visual_selection[0] . '" false %}' . line[visual_selection[2]+1 :]
        else
            let newline = line[: visual_selection[1]-1] . '{% post_link ' . substitute(visual_selection[0], '\s', '-', 'g') .
                        \ ' "' . visual_selection[0] . '" false %}' . line[visual_selection[2]+1 :]
        endif
    else
        let matchp = match(line, '\S')
        let matchn = match(line, '\s', matchp)
        while matchp > col || matchn <= col
            let matchp = match(line, '\S', matchn)
            let matchn = match(line, '\s', matchp)
            if matchn == -1
                let matchn = strlen(line) + 1
            endif
        endwhile

        let base = line[matchp : matchn - 1]
        if matchp == 0
            let newline = '{% post_link ' . base . ' "' . base . '" false %}' . line[matchn :]
        else
            let newline = line[: matchp-1] . '{% post_link ' . base . ' "' . base . '" false %}' . line[matchn :]
        endif
    endif

    call setline(line('.'), newline)
    return base != '' ? base . '.md' : ''
endfunction

" Create or follow ori_link link
function! g:FollowLink() abort
    let link_pattern = '{%\s*post_link.\{-1,}%}'
    let line = getline('.')
    let col = col('.') - 1

    " If cursor is in a link, get the beginning and end of the link.
    let matchb = match(line, link_pattern)
    let matche = matchend(line, link_pattern)
    " echo line[matchb:matche-1]
    " check if cursor is in a link
    while matchb != -1 && (matchb > col || matche <= col)
        let matchb = match(line, link_pattern, matche)
        let matche = matchend(line, link_pattern, matchb)
    endwhile

    " No link in current line
    if matchb == -1
        " Create a link
        let new_file = g:Create_link(mode())
        if new_file != '' && g:hexowiki_follow_after_create
            execute 'edit ' . new_file
        endif
        return
    endif

    " Go to the the file specified by the link.
    let match_list = matchlist(line[matchb : matche-1], '{%\s*post_link\s\+\([^ ]\+\).\{-1,}%}')
    execute 'edit ' . g:hexowiki_home . match_list[1] . '.md'

endfunction

nnoremap <CR> <cmd>call FollowLink()<CR>
xnoremap <CR> <ESC>gv<cmd>call FollowLink()<CR><ESC>
