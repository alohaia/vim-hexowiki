"---------------------------------------\ config /---------------------------------------
let g:hexowiki_skeleton = {
            \ 'post': '~/aloha.github.io/scaffolds/post.md',
            \ 'page': '~/aloha.github.io/scaffolds/page.md',
            \ 'draft': '~/aloha.github.io/scaffolds/draft.md'
            \ }

let g:hexowiki_home = '~/aloha.github.io/source/_posts'

if expand('%:p:h') == expand(g:hexowiki_home) || expand('%:p:h') == expand(g:hexowiki_home)[:-2]
    let s:at_home = 1
else
    let s:at_home = 0
endif

"---------------------------------------\ plugin /---------------------------------------
if exists('g:hexowiki_loaded') || &compatible
  finish
endif
let g:hexowiki_loaded = 1

"---------------------------------\ initialize a file /----------------------------------
function! s:initFile() abort
    " TODO: detect page type
    let l:type = 'post'

    call system('hexo new ' . l:type . ' ' . expand('%:t:r'))
    edit
endfunction

if s:at_home == 1
    augroup hexowiki
        au!
        autocmd BufNewFile *.md call s:initFile() 
    augroup END
endif

