" Quit if syntax file is already loaded
if exists('b:current_syntax')
  finish
endif

"+-------------------------------------------------------------------------------------+
"|                                     \ Syntax /                                      |
"+-------------------------------------------------------------------------------------+

"------------------------------------\ Pre-Settings /-----------------------------------
syn iskeyword @,48-57,192-255,$,_
syn sync fromstart

"---------------------------------------\ Header /--------------------------------------
syn region HWHeader start='\%^---$' end='^---$' contains=HWHeaderItem,HWHeaderList keepend fold
syn match  HWHeaderItem '^\(title\|comments\|mathjax\|date\|tags\|categories\)' contained
syn region HWHeaderList matchgroup=HWHeaderListDelimiter start='^\s*-\s\+' end='$' contained

"------------------------------\ Original link or image /------------------------------
syn region HWLink matchgroup=HWLinkDelimiter start='!\?\zs\[\ze.\{-1,}' end='\](.\{-1,})' keepend oneline concealends
    \ contains=@NoSpell,HWEmoji,HWKeyword,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag
syn region HWLink matchgroup=HWLinkDelimiter start='!\?\zs\[\](' end=')' keepend oneline concealends
    \ contains=@NoSpell
syn region HWHtmlLink matchgroup=HWHtmlLinkDelimiter start='<a.\{-}>' end='</a>' keepend oneline concealends
    \ contains=@NoSpell,HWEmoji,HWKeyword,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag
syn match  HWRawLink '\(https\?\|ftp\)://[^ ]\+' contains=@NoSpell keepend

syn cluster CHWLink contains=HWLink,HWHtmlLink,HWRawLink

"--------------------------------------\ Heading /--------------------------------------
syn region HWHeading1 matchgroup=HWH1Delimiter start='^#\s\+'      end='$' keepend oneline
syn region HWHeading2 matchgroup=HWH2Delimiter start='^##\s\+'     end='$' keepend oneline
syn region HWHeading3 matchgroup=HWH3Delimiter start='^###\s\+'    end='$' keepend oneline
syn region HWHeading4 matchgroup=HWH4Delimiter start='^####\s\+'   end='$' keepend oneline
syn region HWHeading5 matchgroup=HWH5Delimiter start='^#####\s\+'  end='$' keepend oneline
syn region HWHeading6 matchgroup=HWH6Delimiter start='^######\s\+' end='$' keepend oneline
syn match  HWHeading2 '^.*$\n\ze-----*$' keepend

syn cluster CHWHeading contains=HWHeading1,HWHeading2,HWHeading3,HWHeading4,HWHeading5,HWHeading6

"----------------------------------------\ Line /---------------------------------------
syn match  HWLine '^-----*$'

"-------------------------------------\ Reference /-------------------------------------
syn region HWReference start='^>\s*' end='$' oneline 
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   HWReference,HWCodeBlock,HWMathBlock,HWList,@CHWTagBlock,
    \   HWReferenceHead
syn match  HWReferenceHead '^>' contains=HWReferenceHead nextgroup=HWReference contains=HWReferenceHead contained conceal cchar=▊

"--------------------------------------\ Comment /--------------------------------------
syn match HWComment '<!--.*-->'

"-------------------------------------\ Code Block /------------------------------------
" syn region HWInlineCode matchgroup=HWCodeDelimiter start="[^`]\{-}\zs`\ze[^`]\{-1,}" end="[^`]\{-1,}\zs`\ze[^`]\{-}" contains=@NoSpell keepend oneline concealends
syn region HWInlineCode matchgroup=HWCodeDelimiter start="`" end="`" contains=@NoSpell keepend oneline concealends
syn region HWInlineCode matchgroup=HWCodeDelimiter start="`` \=" end=" \=``" contains=@NoSpell keepend oneline concealends
syn region HWInlineCode matchgroup=HWCodeDelimiter start="``` \=" end=" \=```" contains=@NoSpell keepend oneline concealends
syn region HWCodeBlock  matchgroup=HWCodeDelimiter contains=@NoSpell keepend concealends fold
    \ start='^\s*\zs```\ze.\+$' end='^\s*\zs```$'

"----------------------------------------\ Math /---------------------------------------
syn region HWInlineMath matchgroup=HWMathDelimiter contains=@NoSpell keepend oneline concealends display
    \ start='[^$]*\zs\$\ze[^$]*' end='[^$]*\zs\$\ze[^$]*' 
syn region HWMathBlock  matchgroup=HWMathDelimiter contains=@NoSpell keepend concealends display fold
    \ start='^\s*\$\$$' end='^\s*\$\$$' 

syn cluster CHWInlineCM contains=HWInlineCode,HWInlineMath

"---------------------------------------\ Emoji /---------------------------------------
" syn match HWEmoji ':[^:\u0020\u0009]\+:'
syn match HWEmoji ':\w\+:'
" syn region HWEmoji matchgroup=HWEmojiDelimiter start=':\ze[^ ]*:' end=':[^ ]*\zs:' keepend oneline concealends

"---------------------------------------\ Define /--------------------------------------
" syn region HWDefine start='^[^:].*\n:\s\+' end='^:.*\n[^:]*.*\n' contains=HWDefineHead,HWDefineContent keepend fold
syn region HWDefine start='^[^:~\u0020\u0009].*\n\+\s*[:~]' end='\ze\n\{2,}[^:~\u0020\u0009]' keepend fold transparent
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   HWReference,HWCodeBlock,HWMathBlock,HWList,@CHWTagBlock,
    \   HWDefineHead,HWDefineContent 
syn match HWDefineHead '^[^:~\u0020\u0009].*$' contained keepend
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
syn region HWDefineContent matchgroup=HWDefineContentDelimiter start='^\s*[:~]\s\+' end='\ze\n\s*[:~]\s\+' contained keepend
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   HWReference,HWCodeBlock,HWMathBlock,HWList,@CHWTagBlock

"----------------------------------------\ Abbr /---------------------------------------
syn match HWAbbr '^\*\[.*\]: .*$' keepend
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   HWAbbrHead
syn region HWAbbrHead matchgroup=HWAbbrHeadDelimiter start='^\*\zs\[' end='\]\ze:\s\+' contained keepend concealends oneline
" syn match HWAbbrHead '\(^\*\zs\[\|\]\ze:\s\+\)' contained keepend conceal

"---------------------------------------\ Footer /--------------------------------------
syn region HWFooter matchgroup=HWFooterDelimiter start='^\[\ze\^' end='\]\ze: .*$' skip='\\]' keepend concealends oneline
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag
syn region HWFooterAnchor matchgroup=HWFooterAnchorDelimiter start='\[\ze\^' end='\]\ze\([^:]\|\n\)' skip='\\]' keepend concealends oneline

"----------------------------------\ Text declaration /---------------------------------
syn match HWSub '\~[^~ ]\+\~'hs=s+1,he=e-1 keepend
    \ contains=HWInsert,HWDelete,HWItalic,HWBold,HWHighlight,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag
syn match HWSup '\^[^^ ]\+\^'hs=s+1,he=e-1 keepend
    \ contains=HWSub,HWInsert,HWDelete,HWItalic,HWBold,HWHighlight,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag
syn region HWInsert matchgroup=HWInsertDelimiter start='++' end='++' keepend oneline concealends
    \ contains=HWSub,HWSup,HWDelete,HWItalic,HWBold,HWHighlight,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag
syn region HWDelete matchgroup=HWDeleteDelimiter start='\~\~' end='\~\~' keepend oneline concealends
    \ contains=HWSub,HWSup,HWInsert,HWItalic,HWBold,HWHighlight,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag
syn region HWItalic matchgroup=HWItalicDelimiter keepend oneline concealends
    \ start='[^*]\{-}\zs\*\ze[^*]\{-}' end='[^*]\{-}\zs\*\ze[^*]\{-}' 
    \ contains=HWSub,HWSup,HWInsert,HWDelete,HWBold,HWHighlight,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag
syn match HWBold '\*\*[^*]\+\*\*' keepend
    \ contains=HWSub,HWSup,HWInsert,HWDelete,HWItalic,HWHighlight,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag
syn region HWHighlight matchgroup=HWHighlightDelimiter start='==' end='==' keepend oneline concealends
    \ contains=HWSub,HWSup,HWInsert,HWDelete,HWItalic,HWBold,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag

syn cluster CHWTextDeclaration contains=HWSub,HWSup,HWInsert,HWDelete,HWItalic,HWBold,HWHighlight

"---------------------------------------\ lists /---------------------------------------
syn match HWList '^\s*\zs\(\d\+\.\|\d\+)\|-\|\*\|+\)\ze\s\+'
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag

"------------------------------------\ Tags plugin /------------------------------------
syn region HWTag matchgroup=HWTagDelimiter start='{%\s*' end='\s*%}' contains=@NoSpell keepend oneline concealends
syn region HWTagCodeBlock matchgroup=HWTagCodeBlockDelimiter contains=@NoSpell keepend concealends fold
    \ start='^{%\s*\z(codeblock\s\+.\{-1,}\)\s*%}$' end='{%\s*endcodeblock\s*%}'
syn region HWTagPostLink matchgroup=HWTagPostLinkDelimiter contains=@NoSpell keepend oneline concealends
    \ start=+{%\s*+ end=+\s\+\(true\|false\)\s*%}+
syn region HWTagPostLink matchgroup=HWTagPostLinkDelimiter contains=@NoSpell keepend oneline concealends
    \ start=+{%\s*\S\+\s\+['"]+ end=+['"]\s\+\(true\|false\)\s*%}+

syn cluster CHWInlineTag contains=HWTag,HWTagPostLink
syn cluster CHWTagBlock  contains=HWTagCodeBlock

"--------------------------------------\ Keywords /-------------------------------------
syn keyword HWKeyword TODO Same See toc TOC

"+-------------------------------------------------------------------------------------+
"|                                    \ Highlight /                                    |
"+-------------------------------------------------------------------------------------+

"---------------------------------------\ Header /--------------------------------------
hi link HWHeader Define
hi link HWHeaderItem Keyword
hi link HWHeaderListDelimiter HWList

"------------------------------\ Original link or image /------------------------------
hi HWRawLink cterm=underline,bold gui=underline,bold
hi link HWLink HWRawLink
hi link HWHtmlLink HWRawLink

"--------------------------------------\ Heading /--------------------------------------
hi HWHeading1 cterm=bold gui=bold ctermfg=9  guifg=#e08090
hi HWHeading2 cterm=bold gui=bold ctermfg=10 guifg=#80e090
hi HWHeading3 cterm=bold gui=bold ctermfg=12 guifg=#6090e0
hi HWHeading4 cterm=bold gui=bold ctermfg=15 guifg=#c0c0f0
hi HWHeading5 cterm=bold gui=bold ctermfg=15 guifg=#d5d5d5
hi HWHeading6 cterm=bold gui=bold ctermfg=15 guifg=#f9f9f9
hi HWLine     cterm=bold gui=bold ctermfg=59 guifg=#5C6370

hi HWH1Delimiter ctermfg=204 guifg=#dddddd
hi HWH2Delimiter ctermfg=204 guifg=#dddddd
hi HWH3Delimiter ctermfg=204 guifg=#dddddd
hi HWH4Delimiter ctermfg=204 guifg=#dddddd
hi HWH5Delimiter ctermfg=204 guifg=#dddddd
hi HWH6Delimiter ctermfg=204 guifg=#dddddd

"-------------------------------------\ Reference /-------------------------------------
hi HWReference cterm=italic gui=italic ctermfg=59 guifg=#5C6370
hi HWReferenceHead ctermfg=59 guifg=#5C6370

"--------------------------------------\ Comment /--------------------------------------
hi link HWComment Comment

"-------------------------------------\ Code Block /------------------------------------
hi HWInlineCode cterm=italic gui=italic ctermfg=114 guifg=#98C379
hi HWCodeBlock  ctermfg=114 guifg=#98C379

"----------------------------------------\ Math /---------------------------------------
hi HWInlineMath cterm=italic gui=italic ctermfg=180 guifg=#E5C07B
hi HWMathBlock  ctermfg=180 guifg=#E5C07B

"---------------------------------------\ Emoji /---------------------------------------
hi HWEmoji cterm=standout gui=standout

"---------------------------------------\ Define /--------------------------------------
hi HWDefineHead cterm=bold gui=bold
hi link HWDefineContent Comment

"----------------------------------------\ Abbr /---------------------------------------
hi HWAbbrHead cterm=bold,underline gui=bold,underline

"---------------------------------------\ Footer /--------------------------------------
hi HWFooter       cterm=bold,underline gui=bold,underline
hi HWFooterAnchor cterm=italic,underline gui=italic,underline

"----------------------------------\ Text declaration /---------------------------------
hi HWSub cterm=italic,bold gui=italic,bold
hi HWSup cterm=italic,bold gui=italic,bold
hi HWInsert cterm=underline gui=underline
hi HWDelete cterm=strikethrough gui=strikethrough
hi HWItalic cterm=italic gui=italic
hi HWBold cterm=bold gui=bold
hi HWHighlight cterm=standout gui=standout

"---------------------------------------\ lists /---------------------------------------
hi HWList ctermfg=204 guifg=#E06C75

"------------------------------------\ Tags plugin /------------------------------------
hi HWTag cterm=italic,underline gui=italic,underline
hi link HWTagCodeBlock HWCodeBlock
hi link HWTagPostLink HWRawLink

"--------------------------------------\ Keywords /-------------------------------------
hi link HWKeyword Keyword

let b:current_syntax = 'markdown'
