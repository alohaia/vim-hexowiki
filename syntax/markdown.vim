" Quit if syntax file is already loaded
if exists('b:current_syntax')
  finish
endif

"+-------------------------------------------------------------------------------------+
"|                                     \ Syntax /                                      |
"+-------------------------------------------------------------------------------------+

"------------------------------------\ Pre-Settings /-----------------------------------
syntax iskeyword @,48-57,192-255,$,_
syntax sync fromstart

"---------------------------------------\ Header /--------------------------------------
syn region HexowikiHeader start='\%^---$' end='^---$' contains=HexowikiHeaderItem,HexowikiHeaderList keepend fold
syn match  HexowikiHeaderItem '^\(title\|comments\|mathjax\|date\|tags\|categories\)' contained
syn region HexowikiHeaderList matchgroup=HexowikiHeaderListDelimiter start='^\s*-\s\+' end='$' contained containedin=HexowikiHeader
"------------------------------\ Original link or image /------------------------------
syn region HexowikiLink matchgroup=HexowikiLinkDelimiter start='!\?\zs\[\ze.\{-1,}' end='\](.\{-1,})' contains=ALL,@NoSpell keepend oneline concealends
syn region HexowikiLink matchgroup=HexowikiLinkDelimiter start='!\?\zs\[\](' end=')' contains=ALL,@NoSpell keepend oneline concealends
syn region HexowikiHtmlLink matchgroup=HexowikiHtmlLinkDelimiter start='<a.\{-}>' end='</a>' contains=ALL,@NoSpell keepend oneline concealends
syn match  HexowikiRawLink '\(https\?\|localhost\|ftp\)://[^ ]\+' contains=ALL,@NoSpell keepend

"--------------------------------------\ Heading /--------------------------------------
syn region HexowikiHeading1 matchgroup=HexowikiH1Delimiter start='^#\s\+'      end='$' keepend oneline
syn region HexowikiHeading2 matchgroup=HexowikiH2Delimiter start='^##\s\+'     end='$' keepend oneline
syn region HexowikiHeading3 matchgroup=HexowikiH3Delimiter start='^###\s\+'    end='$' keepend oneline
syn region HexowikiHeading4 matchgroup=HexowikiH4Delimiter start='^####\s\+'   end='$' keepend oneline
syn region HexowikiHeading5 matchgroup=HexowikiH5Delimiter start='^#####\s\+'  end='$' keepend oneline
syn region HexowikiHeading6 matchgroup=HexowikiH6Delimiter start='^######\s\+' end='$' keepend oneline
syn match  HexowikiLine '^-----*$'
syn match  HexowikiHeading2 '^.*$\n\ze-----*$' keepend


"-------------------------------------\ Reference /-------------------------------------
syn match HexowikiReference '\(^>\s\+.*$\)\+' contains=ALL
syn region HexowikiReferenceContext matchgroup=HexowikiReferenceDelimiter start='^>\s\+' end='$' oneline contains=ALL containedin=HexowikiReference

"--------------------------------------\ Comment /--------------------------------------
syn match HexowikiComment '<!--.*-->'

"-------------------------------------\ Code Block /------------------------------------
" syn region HexowikiInlineCode matchgroup=HexowikiCodeDelimiter start="[^`]\{-}\zs`\ze[^`]\{-1,}" end="[^`]\{-1,}\zs`\ze[^`]\{-}" contains=@NoSpell keepend oneline concealends
syn region HexowikiInlineCode matchgroup=HexowikiCodeDelimiter start="`" end="`" contains=@NoSpell keepend oneline concealends
syn region HexowikiInlineCode matchgroup=HexowikiCodeDelimiter start="`` \=" end=" \=``" contains=@NoSpell keepend oneline concealends
syn region HexowikiInlineCode matchgroup=HexowikiCodeDelimiter start="``` \=" end=" \=```" contains=@NoSpell keepend oneline concealends
syn region HexowikiCodeBlock  matchgroup=HexowikiCodeDelimiter start='^\s*\zs```\ze.\+$' end='^\s*\zs```$' contains=@NoSpell keepend concealends fold

"----------------------------------------\ Math /---------------------------------------
syn region HexowikiInlineMath matchgroup=HexowikiMathDelimiter start='[^$]*\zs\$\ze[^$]*' end='[^$]*\zs\$\ze[^$]*' contains=@NoSpell keepend oneline concealends display
syn region HexowikiMathBlock  matchgroup=HexowikiMathDelimiter start='^\s*\$\$$' end='^\s*\$\$$' contains=@NoSpell keepend concealends display fold

"---------------------------------------\ Emoji /---------------------------------------
" syn match HexowikiEmoji ':[^:\u0020\u0009]\+:'
syn match HexowikiEmoji ':\w\+:'
" syn region HexowikiEmoji matchgroup=HexowikiEmojiDelimiter start=':\ze[^ ]*:' end=':[^ ]*\zs:' keepend oneline concealends

"---------------------------------------\ Define /--------------------------------------
" syn region HexowikiDefine start='^[^:].*\n:\s\+' end='^:.*\n[^:]*.*\n' contains=HexowikiDefineHead,HexowikiDefineContent keepend fold
syn match HexowikiDefine '^[^:\u0020\u0009].*\n\(^:\s\+.*\n\)\+' contains=ALL keepend fold
syn match HexowikiDefineHead '^[^:].*$' contained contains=ALL nextgroup=HexowikiDefineContent keepend
syn region HexowikiDefineContent matchgroup=HexowikiDefineContentDelimiter start='^:\zs\s\+' end='$' containedin=HexowikiDefine contains=ALL keepend

"----------------------------------\ Text declaration /---------------------------------
" syn region HexowikiSub  matchgroup=HexowikiSubDelimiter start='[^~]\zs\~\ze[0-9A-z_-]\+' end='[0-9A-z_-]\+\zs\~\ze[^~]*' keepend oneline concealends
" syn region HexowikiSup  matchgroup=HexowikiSupDelimiter start='\^\ze[0-9A-z_-]\+' end='[0-9A-z_-]\+\zs\^' keepend oneline concealends
" syn region HexowikiSub  matchgroup=HexowikiSubDelimiter start='[^~]\{-}\zs\~\ze[^~]\{-}' end='[^~]\{-}\zs\~\ze[^~]\{-}' contains=ALL keepend oneline concealends
syn match HexowikiSub '\~[^~ ]\+\~'hs=s+1,he=e-1
" syn region HexowikiSup  matchgroup=HexowikiSupDelimiter start='\^\ze[^^ ]\{-1,}' end='^' contains=ALL keepend oneline concealends
syn match HexowikiSup '\^[^^ ]\+\^'hs=s+1,he=e-1
syn region HexowikiInsert matchgroup=HexowikiInsertDelimiter start='++' end='++' contains=ALL keepend oneline concealends
syn region HexowikiDelete matchgroup=HexowikiDeleteDelimiter start='\~\~' end='\~\~' contains=ALL keepend oneline concealends
syn region HexowikiItalic matchgroup=HexowikiItalicDelimiter start='[^*]\{-}\zs\*\ze[^*]\{-}' end='[^*]\{-}\zs\*\ze[^*]\{-}' contains=ALL keepend oneline concealends
" syn region HexowikiBold matchgroup=HexowikiBoldDelimiter start='\*\*' end='\*\*' contains=ALL keepend oneline concealends
syn match HexowikiBold '\*\*[^*]\+\*\*' contains=ALL keepend
syn region HexowikiHighlight matchgroup=HexowikiHighlightDelimiter start='==' end='==' contains=ALL keepend oneline concealends

"---------------------------------------\ lists /---------------------------------------
syn match HexowikiList '^\s*\zs\(\d\+\.\|\d\+)\|-\|\*\|+\)\ze\s\+'

"------------------------------------\ Tags plugin /------------------------------------
syn region HexowikiTag matchgroup=HexowikiTagDelimiter start='{%\s*[a-z_]\+\s\+' end='\s*%}' contains=@NoSpell keepend oneline concealends
syn region HexowikiTagCodeBlock matchgroup=HexowikiTagCodeBlockDelimiter start='^{%\s*\z(codeblock\s\+.\{-1,}\)\s*%}$' end='{%\s*endcodeblock\s*%}' contains=@NoSpell keepend concealends fold
syn region HexowikiTagPostLink matchgroup=HexowikiTagPostLinkDelimiter start=+{%\s*post_link\s\++ end=+\s\+\(true\|false\)\s*%}+ contains=@NoSpell keepend oneline concealends
syn region HexowikiTagPostLink matchgroup=HexowikiTagPostLinkDelimiter start=+{%\s*post_link\s\+\S\+\s\+['"]+ end=+['"]\s\+\(true\|false\)\s*%}+ contains=@NoSpell keepend oneline concealends

"--------------------------------------\ Keywords /-------------------------------------
syn keyword HexowikiKeyword TODO Same See toc TOC

"+-------------------------------------------------------------------------------------+
"|                                    \ Highlight /                                    |
"+-------------------------------------------------------------------------------------+

"---------------------------------------\ Header /--------------------------------------
hi link HexowikiHeader Define
hi link HexowikiHeaderItem Keyword
hi link HexowikiHeaderListDelimiter HexowikiList

"------------------------------\ Original link or image /------------------------------
hi HexowikiRawLink cterm=underline,bold gui=underline,bold
hi link HexowikiLink HexowikiRawLink
hi link HexowikiHtmlLink HexowikiRawLink

"--------------------------------------\ Heading /--------------------------------------
hi HexowikiHeading1 cterm=bold gui=bold ctermfg=9  guifg=#e08090
hi HexowikiHeading2 cterm=bold gui=bold ctermfg=10 guifg=#80e090
hi HexowikiHeading3 cterm=bold gui=bold ctermfg=12 guifg=#6090e0
hi HexowikiHeading4 cterm=bold gui=bold ctermfg=15 guifg=#c0c0f0
hi HexowikiHeading5 cterm=bold gui=bold ctermfg=15 guifg=#d5d5d5
hi HexowikiHeading6 cterm=bold gui=bold ctermfg=15 guifg=#f9f9f9
hi HexowikiLine     cterm=bold gui=bold ctermfg=59 guifg=#5C6370

hi HexowikiH1Delimiter ctermfg=204 guifg=#dddddd
hi HexowikiH2Delimiter ctermfg=204 guifg=#dddddd
hi HexowikiH3Delimiter ctermfg=204 guifg=#dddddd
hi HexowikiH4Delimiter ctermfg=204 guifg=#dddddd
hi HexowikiH5Delimiter ctermfg=204 guifg=#dddddd
hi HexowikiH6Delimiter ctermfg=204 guifg=#dddddd

"-------------------------------------\ Reference /-------------------------------------
hi HexowikiReferenceContext cterm=italic gui=italic ctermfg=59 guifg=#5C6370

"--------------------------------------\ Comment /--------------------------------------
hi link HexowikiComment Comment

"-------------------------------------\ Code Block /------------------------------------
hi HexowikiInlineCode cterm=italic gui=italic ctermfg=114 guifg=#98C379
hi HexowikiCodeBlock  ctermfg=114 guifg=#98C379

"----------------------------------------\ Math /---------------------------------------
hi HexowikiInlineMath cterm=italic gui=italic ctermfg=180 guifg=#E5C07B
hi HexowikiMathBlock  ctermfg=180 guifg=#E5C07B

"---------------------------------------\ Emoji /---------------------------------------
hi HexowikiEmoji cterm=standout gui=standout

"---------------------------------------\ Define /--------------------------------------
hi HexowikiDefineHead cterm=bold gui=bold
hi link HexowikiDefineContent Comment

"----------------------------------\ Text declaration /---------------------------------
hi HexowikiSub cterm=italic,bold gui=italic,bold
hi HexowikiSup cterm=italic,bold gui=italic,bold
hi HexowikiInsert cterm=underline gui=underline
hi HexowikiDelete cterm=strikethrough gui=strikethrough
hi HexowikiItalic cterm=italic gui=italic
hi HexowikiBold cterm=bold gui=bold
hi HexowikiHighlight cterm=standout gui=standout

"---------------------------------------\ lists /---------------------------------------
hi HexowikiList ctermfg=204 guifg=#E06C75

"------------------------------------\ Tags plugin /------------------------------------
hi HexowikiTag cterm=italic,underline gui=italic,underline
hi link HexowikiTagCodeBlock HexowikiCodeBlock
hi link HexowikiTagPostLink HexowikiRawLink

"--------------------------------------\ Keywords /-------------------------------------
hi link HexowikiKeyword Keyword

let b:current_syntax = 'markdown'
