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
function! g:WcharLen(charfb)
    let cmasks = [128, 224, 240, 248, 252, 254]
    let cvals  = [  0, 192, 224, 240, 248, 252]
    let char_nr = char2nr(a:charfb)
    for i in range(6)
        if and(char_nr, cmasks[i]) == cvals[i]
            return i+1
        endif
    endfor
endfunction

function! g:VisualInline()
    let vbegin = col("'<") - 1
    let vend   = col("'>") - 1
    if s:is_ascii("'>") != v:true
        let vend += g:WcharLen(getline('.')[vend]) - 1
    endif
    return [getline('.')[vbegin:vend], vbegin, vend]
endfunction

" Create a new link under the cursor
"
" Return:
"   - Empty string if failed.
"   - Name of new file if Succeed.
function! g:CreateLink(mode)
    let line = getline('.')
    let col = col('.') - 1

    if char2nr(line[col]) == 32 || char2nr(line[col]) == 9 || char2nr(line[col]) == 0
        echo 'Not on any valid text'
        return ''
    endif

    if a:mode == 'v' || a:mode == 'V'
        " Visual mode
        let visual_selection = VisualInline()
        let base = visual_selection[0]
        echo visual_selection
        if visual_selection[1] == 0
            let newline = '<a href="{% post_path ' . substitute(visual_selection[0], '\s', '-', 'g') . ' %}">' .
                        \ visual_selection[0] . '</a>' . line[visual_selection[2]+1 :]
        else
            let newline = line[: visual_selection[1]-1] . '<a href="{% post_path ' . substitute(visual_selection[0], '\s', '-', 'g') . ' %}">' .
                        \ visual_selection[0] . '</a>' . line[visual_selection[2]+1 :]
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
            let newline = '<a href="{% post_path ' . base . ' %}">' . base. '"</a>' . line[matchn :]
        else
            let newline = line[: matchp-1] . '<a href="{% post_path ' . base . ' %}">' . base. '"</a>' . line[matchn :]
        endif
    endif

    call setline(line('.'), newline)
    return base != '' ? base . '.md' : ''
endfunction

" Create or follow ori_link link
function! g:FollowLink() abort
    let link_patterns = [
        \ '{%\s*post_link\s\+.\{-1,}%}',
        \ '<a\s\+href=[''"]{%\s\+post_path\s\+\(.\{-1,}\)\s*%}\(#.\{-1,}\)\?[''"]>.\{-}<\/a>',
        \ '\[.\{-1,}\](\(#.\{-1,}\))',
        \ '!\?\[.\{-1,}\](\([^#]\{-1,}\))'
        \ ]
    let line = getline('.')
    let col = col('.') - 1

    let link_type = 0
    let matchb = -1
    let matche = -1
    for link_type in range(4)
        " If cursor is in a link, get the beginning and end of the link.
        let matchb = match(line, link_patterns[link_type])
        " No link in this line
        if matchb == -1
            continue
        endif
        let matche = matchend(line, link_patterns[link_type])

        " check if cursor is in a link
        while matchb != -1 && (col < matchb || col >= matche)
            let matchb = match(line, link_patterns[link_type], matche)
            let matche = matchend(line, link_patterns[link_type], matchb)
        endwhile

        " find a link under cursor
        if matchb != -1
            break
        endif
    endfor

    " No link in current line
    if matchb == -1
        " Create a link under cursor
        let new_file = g:CreateLink(mode())
        if new_file != '' && g:hexowiki_follow_after_create
            execute 'edit ' . new_file
        endif
    " Jump somewhere according to `link_type`
    elseif link_type == 0
        " Go to the the file specified by the link.
        let match_list = matchlist(line[matchb : matche-1], '{%\s*post_link\s\+\([^\u0020\u0009]\+\).\{-1,}%}')
        execute 'edit ' . g:hexowiki_home . match_list[1] . '.md'
    elseif link_type == 1
        let m = matchlist(line[matchb:matche-1], link_patterns[link_type])
        execute 'edit ' . m[1] . '.md'
        if m[2] != ''
            call search('#\+\s\+' . m[2][1:])
        endif
    elseif link_type == 2
        let m = matchlist(line[matchb:matche-1], link_patterns[link_type])
        call search('#\+\s\+' . m[1][1:])
    elseif link_type == 3
        let m = matchlist(line[matchb:matche-1], link_patterns[link_type])
        call system('xdg-open ' . m[1])
    else
        echo '[g:FollowLink] undefined'
    endif

endfunction

nnoremap <CR> <cmd>call FollowLink()<CR>
xnoremap <CR> <ESC>gv<cmd>call FollowLink()<CR><ESC>

inoremap <expr> ： getline('.') == '' ? ': ' : '：' 
inoremap <expr> 》 getline('.') == '' ? '> ' : '》' 
