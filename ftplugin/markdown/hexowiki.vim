" Vim plugin for writing hexo posts
" Maintainer: Qihuan Liu <liu.qihuan@outlook.com>

if exists('b:did_hexowiki') || &compatible
  finish
endif
let b:did_hexowiki = 1

if g:hexowiki_disable_fold == 0
    setlocal foldmethod=expr
    setlocal foldexpr=hexowiki#foldexpr(v:lnum)
    setlocal foldtext=hexowiki#foldtext()
endif

if !hasmapto('<Plug>FollowLinkN')
    nmap <buffer> <CR> <Plug>FollowLinkN
end
if !hasmapto('<Plug>FollowLinkV')
    xmap <buffer> <CR> <Plug>FollowLinkV
end
if !hasmapto('<Plug>FindLinkP')
    nmap <buffer> <Leader>lp <Plug>FindLinkP
end
if !hasmapto('<Plug>FindLinkN')
    nmap <buffer> <Leader>ln <Plug>FindLinkN
end

if g:hexowiki_use_imaps == 1
    inoremap <buffer><unique> <expr> ： col('.') == 1 ? ': ' : '：'
    inoremap <buffer><unique> <expr> :  col('.') == 1 ? ': ' : ':'
    inoremap <buffer><unique> <expr> 》 col('.') == 1 ? '> ' : '》'
    inoremap <buffer><unique> <expr> >  col('.') == 1 ? '> ' : '>'
endif

noremap <buffer><unique> <M-CR> <Cmd>lua require'rmd'.run_block()<CR>
