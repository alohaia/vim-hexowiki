" Quit if syntax file is already loaded
if exists('b:current_syntax')
  finish
endif

"+-------------------------------------------------------------------------------------+
"|                                     \ Syntax /                                      |
"+-------------------------------------------------------------------------------------+

"---------------------------------------\ Header /--------------------------------------
syn region HexowikiHeader start='\%^---$' end='^---$' contains=HexowikiHeaderItem keepend
syn match  HexowikiHeaderItem '^\(title\|comments\|mathjax\|date\|tags\|categories\)' contained

"------------------------------\ Original link or image /------------------------------
syn region HexowikiLink1 matchgroup=HexowikiLinkDelimiter start='!\?\[\ze.\+' end='\](.\+)' contains=ALL keepend oneline concealends
syn region HexowikiLink2 matchgroup=HexowikiLinkDelimiter start='!\?\[\](' end=')' contains=ALL keepend oneline concealends
syn match  HexowikiRawLink '\(https\?\|localhost\|ftp\)://[^ ]\+' keepend

"--------------------------------------\ Headings /-------------------------------------
syn region HexowikiHeading1 matchgroup=HexowikiH1Delimiter start='^#\s*'      end='$' keepend oneline
syn region HexowikiHeading2 matchgroup=HexowikiH2Delimiter start='^##\s*'     end='$' keepend oneline
syn region HexowikiHeading3 matchgroup=HexowikiH3Delimiter start='^###\s*'    end='$' keepend oneline
syn region HexowikiHeading4 matchgroup=HexowikiH4Delimiter start='^####\s*'   end='$' keepend oneline
syn region HexowikiHeading5 matchgroup=HexowikiH5Delimiter start='^#####\s*'  end='$' keepend oneline
syn region HexowikiHeading6 matchgroup=HexowikiH6Delimiter start='^######\s*' end='$' keepend oneline

"--------------------------------------\ Comment /--------------------------------------
syn match HexowikiComment '<!--.*-->'

"-------------------------------------\ Code Block /------------------------------------
" syn region HexowikiInlineCode matchgroup=HexowikiCodeDelimiter start="[^`]*\zs`\ze[^`]*" end="[^`]*\zs`\ze[^`]*" keepend oneline concealends
syn region HexowikiCodeBlock  matchgroup=HexowikiCodeDelimiter start='^\s*\zs```\ze.\+$' end='^\s*\zs```$' keepend concealends

"----------------------------------------\ Math /---------------------------------------
syn region HexowikiInlineMath matchgroup=HexowikiMathDelimiter start='[^$]*\zs\$\ze[^$]*' end='[^$]*\zs\$\ze[^$]*' keepend oneline concealends display
syn region HexowikiMathBlock  matchgroup=HexowikiMathDelimiter start='^\s*\$\$$' end='^\s*\$\$$' keepend concealends display

"---------------------------------------\ Emoji /---------------------------------------
" syn match HexowikiEmoji ':[^:\u0020\u0009]\+:'
syn match HexowikiEmoji ':\w\+:'
" syn region HexowikiEmoji matchgroup=HexowikiEmojiDelimiter start=':\ze[^ ]*:' end=':[^ ]*\zs:' keepend oneline concealends

"----------------------------------\ Text declaration /---------------------------------
" syn region HexowikiSub  matchgroup=HexowikiSubDelimiter start='[^~]\zs\~\ze[0-9A-z_-]\+' end='[0-9A-z_-]\+\zs\~\ze[^~]*' keepend oneline concealends
" syn region HexowikiSup  matchgroup=HexowikiSupDelimiter start='\^\ze[0-9A-z_-]\+' end='[0-9A-z_-]\+\zs\^' keepend oneline concealends
syn region HexowikiSub  matchgroup=HexowikiSubDelimiter start='[^~]*\zs\~\ze[^~]*' end='[^~]*\zs\~\ze[^~]*' contains=ALL keepend oneline concealends transparent
syn region HexowikiSup  matchgroup=HexowikiSupDelimiter start='\^' end='\^' contains=ALL keepend oneline concealends transparent
syn region HexowikiInsert matchgroup=HexowikiInsertDelimiter start='++' end='++' contains=ALL keepend oneline concealends transparent
syn region HexowikiDelete matchgroup=HexowikiDeleteDelimiter start='\~\~' end='\~\~' contains=ALL keepend oneline concealends transparent
syn region HexowikiItalic matchgroup=HexowikiItalicDelimiter start='[^*]*\zs\*\ze[^*]*' end='[^*]*\zs\*\ze[^*]*' contains=ALL keepend oneline concealends transparent
syn region HexowikiBold matchgroup=HexowikiBoldDelimiter start='\*\*' end='\*\*' contains=ALL keepend oneline concealends transparent

"---------------------------------------\ lists /---------------------------------------
syn match HexowikiList1 '^\s*\zs\d\+\.\ze\s\+'
syn match HexowikiList2 '^\s*\zs-\ze\s\+'

"------------------------------------\ Tags plugin /------------------------------------
syn region HexowikiTag matchgroup=HexowikiTagDelimiter start='^{%\s*' end='\s*%}$' keepend oneline concealends

"--------------------------------------\ Keywords /-------------------------------------
syn keyword HexowikiKeyword TODO Same See toc TOC

"+-------------------------------------------------------------------------------------+
"|                                    \ Highlight /                                    |
"+-------------------------------------------------------------------------------------+

"---------------------------------------\ Header /--------------------------------------
hi link HexowikiHeader Define
hi link HexowikiHeaderItem Keyword

"------------------------------\ Original link or image /------------------------------
hi HexowikiLink1 cterm=underline,bold gui=underline,bold
hi HexowikiLink2 cterm=underline,bold gui=underline,bold
hi HexowikiRawLink cterm=underline,bold gui=underline,bold

"--------------------------------------\ Headings /-------------------------------------
hi HexowikiHeading1 cterm=bold gui=bold ctermfg=9  guifg=#e08090
hi HexowikiHeading2 cterm=bold gui=bold ctermfg=10 guifg=#80e090
hi HexowikiHeading3 cterm=bold gui=bold ctermfg=12 guifg=#6090e0
hi HexowikiHeading4 cterm=bold gui=bold ctermfg=15 guifg=#c0c0f0
hi HexowikiHeading5 cterm=bold gui=bold ctermfg=15 guifg=#d5d5d5
hi HexowikiHeading6 cterm=bold gui=bold ctermfg=15 guifg=#f9f9f9

hi HexowikiH1Delimiter ctermfg=204 guifg=#dddddd
hi HexowikiH2Delimiter ctermfg=204 guifg=#dddddd
hi HexowikiH3Delimiter ctermfg=204 guifg=#dddddd
hi HexowikiH4Delimiter ctermfg=204 guifg=#dddddd
hi HexowikiH5Delimiter ctermfg=204 guifg=#dddddd
hi HexowikiH6Delimiter ctermfg=204 guifg=#dddddd

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

"----------------------------------\ Text declaration /---------------------------------
hi HexowikiSub cterm=italic,bold gui=italic,bold
hi HexowikiSup cterm=italic,bold gui=italic,bold
hi HexowikiInsert cterm=underline gui=underline
hi HexowikiDelete cterm=strikethrough gui=strikethrough
hi HexowikiItalic cterm=italic gui=italic
hi HexowikiBold cterm=bold gui=bold

"---------------------------------------\ lists /---------------------------------------
hi HexowikiList1 ctermfg=204 guifg=#E06C75
hi HexowikiList2 ctermfg=204 guifg=#E06C75

"------------------------------------\ Tags plugin /------------------------------------
hi HexowikiTag cterm=italic,underline gui=italic,underline

"--------------------------------------\ Keywords /-------------------------------------
hi link HexowikiKeyword Keyword

let b:current_syntax = 'markdown'
