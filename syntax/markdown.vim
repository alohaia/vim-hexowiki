" Vim plugin for writing hexo posts
" Maintainer: Qihuan Liu <liu.qihuan@outlook.com>

if exists('b:current_syntax')
  finish
endif
let b:current_syntax = 'markdown'

"+-------------------------------------------------------------------------------------+
"|                                     \ Syntax /                                      |
"+-------------------------------------------------------------------------------------+

"=======================================\ Beyond /======================================

"------------------------------------\ Pre-Settings /-----------------------------------
syn iskeyword @,48-57,192-255,$,_
syn sync fromstart

"---------------------------------------\ Header /--------------------------------------
syn region HWHeader contains=HWHeaderItem,HWHeaderList keepend fold
    \ start='\%^---$' end='^---$'
exec 'syn match HWHeaderItem +^\(' .. join(g:hexowiki_header_items, '\|') .. '\)+ contained'
syn region HWHeaderList matchgroup=HWHeaderListDelimiter contained
    \ start='^\s*-\s\+' end='$'

"--------------------------------------\ Comment /--------------------------------------
syn match HWComment '<!--.*-->'

"----------------------------------------\ Line /---------------------------------------
syn match  HWLine '^-----*$'

"-------------------------------------\ Code Block /------------------------------------
syn region HWInlineCode matchgroup=HWCodeDelimiter contains=@NoSpell keepend oneline concealends
    \ start="`" end="`"
syn region HWInlineCode matchgroup=HWCodeDelimiter end=" \=``" contains=@NoSpell keepend oneline concealends
    \ start="`` \="
syn region HWInlineCode matchgroup=HWCodeDelimiter end=" \=```" contains=@NoSpell keepend oneline concealends
    \ start="``` \="
syn region HWCodeBlock  matchgroup=HWCodeDelimiter contains=@NoSpell keepend concealends fold
    \ start='^\s*\zs```\ze.\+$' end='^\s*\zs```$'

"----------------------------------------\ Math /---------------------------------------
syn region HWInlineMath matchgroup=HWMathDelimiter contains=@NoSpell keepend oneline concealends display
    \ start='[^$]*\zs\$\ze[^$]*' end='[^$]*\zs\$\ze[^$]*'
syn region HWMathBlock  matchgroup=HWMathDelimiter contains=@NoSpell keepend concealends display fold
    \ start='^\s*\$\$\ze.*' end='\s*.*\zs\$\$$'

syn cluster CHWInlineCM contains=HWInlineCode,HWInlineMath

"---------------------------------------\ Footer /--------------------------------------
" syn match HWFooterAnchor '\[\zs\^.\{-}[^\\]\ze\]\([^:]\|\n\)' keepend
" syn match HWFooter '^\[\zs\^.\{-}[^\\]\ze\]:' keepend
"     \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
"     \   @CHWOthersInline
syn region HWFooterAnchor matchgroup=HWFooterAnchorDelimiter keepend concealends oneline
    \ start='\[\ze\^' end='\]\ze\([^:]\|\n\)' skip='\\]'
syn region HWFooter matchgroup=HWFooterDelimiter keepend concealends oneline
    \ start='^\[\ze\^' end='\]\ze: .*$' skip='\\]'
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   @CHWOthersInline

"----------------------------------------\ Abbr /---------------------------------------
syn match HWAbbr '^\*\[.*\]: .*$' keepend
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   HWAbbrHead
syn region HWAbbrHead matchgroup=HWAbbrHeadDelimiter contained keepend concealends oneline
    \ start='^\*\zs\[' end='\]\ze:\s\+'
" syn match HWAbbrHead '\(^\*\zs\[\|\]\ze:\s\+\)' contained keepend conceal

"------------------------------------\ Tags plugin /------------------------------------
syn region HWTag matchgroup=HWTagDelimiter contains=@NoSpell,HWTag oneline concealends
    \ start='{%\s*' end='\s*%}'
syn region HWTagCodeBlock matchgroup=HWTagCodeBlockDelimiter contains=@NoSpell concealends fold
    \ start='^{%\s*\z(codeblock\s\+.\{-1,}\)\s*%}$' end='{%\s*endcodeblock\s*%}'
syn region HWTagPostLink matchgroup=HWTagPostLinkDelimiter contains=@NoSpell oneline concealends
    \ start=+{%\s*post_link\s\+\S\+\s\++ end=+\s\+\(true\|false\)\s*%}+
syn region HWTagPostLink matchgroup=HWTagPostLinkDelimiter contains=@NoSpell oneline concealends
    \ start=+{%\s*post_link\s\+\S\+\s\+['"]+ end=+['"]\s\+\(true\|false\)\s*%}+
" syn match HWTagHideText '{%\s*\(hidetext\|hdt\)\s\+\S\{-}\s\+%}'

syn cluster CHWInlineTag contains=HWTag,HWTagPostLink,HWTagHideText
syn cluster CHWTagBlock  contains=HWTagCodeBlock

"=======================================\ Inline /======================================

"---------------------------------------\ Escape /--------------------------------------
syn match HWEscape '\\\ze.' conceal

"--------------------------------------\ Keywords /-------------------------------------
syn keyword HWKeyword TODO Same See toc TOC

"---------------------------------------\ Emoji /---------------------------------------
" syn match HWEmoji ':[^:\u0020\u0009]\+:'
syn match HWEmoji ':\w\+:'
" syn region HWEmoji matchgroup=HWEmojiDelimiter start=':\ze[^ ]*:' end=':[^ ]*\zs:' keepend oneline concealends

"------------------------------\ Original link or image /------------------------------
syn region HWLink matchgroup=HWLinkDelimiter keepend oneline concealends
    \ start='!\?\zs\[\ze.\{-1,}' end='\](.\{-1,})'
    \ contains=@NoSpell,HWEmoji,HWKeyword,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag
syn region HWLink matchgroup=HWLinkDelimiter keepend oneline concealends
    \ start='!\?\zs\[\](' end=')'
    \ contains=@NoSpell
syn region HWHtmlLink matchgroup=HWHtmlLinkDelimiter keepend oneline concealends
    \ start='<a.\{-}>' end='</a>'
    \ contains=@NoSpell,HWEmoji,HWKeyword,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag
syn match  HWRawLink '\(https\?\|ftp\)://[^ ]\+' contains=@NoSpell keepend

syn cluster CHWLink contains=HWLink,HWHtmlLink,HWRawLink

"----------------------------------\ Text declaration /---------------------------------
syn region HWSub keepend oneline
    \ start='[^~]\{-}\zs\~' end='\~\ze[^~]\{-}' skip='\\\~'
    \ contains=HWInsert,HWDelete,HWItalic,HWBold,HWHighlight,HWItalicBold,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   @CHWOthersInline
syn region HWSup keepend oneline
    \ start='[^^]\{-}\zs\^' end='\^\ze[^^]\{-}' skip='\\\^'
    \ contains=HWSub,HWInsert,HWDelete,HWItalic,HWBold,HWHighlight,HWItalicBold,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   @CHWOthersInline
syn region HWInsert matchgroup=HWInsertDelimiter keepend oneline concealends
    \ start='[^+]\{-}\zs++' end='++\ze[^+]\{-}' skip='\\++'
    \ contains=HWSub,HWSup,HWDelete,HWItalic,HWBold,HWHighlight,HWItalicBold,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   @CHWOthersInline
syn region HWDelete matchgroup=HWDeleteDelimiter keepend oneline concealends
    \ start='[^~]\{-}\zs\~\~' end='\~\~\ze[^~]\{-}' skip='\\\~\~'
    \ contains=HWSub,HWSup,HWInsert,HWItalic,HWBold,HWHighlight,HWItalicBold,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   @CHWOthersInline
syn region HWItalic matchgroup=HWItalicDelimiter keepend oneline concealends
    \ start='\*' end='\*' skip='\\\*'
    \ contains=HWSub,HWSup,HWInsert,HWDelete,HWBold,HWHighlight,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   @CHWOthersInline
syn region HWBold matchgroup=HWBoldDelimiter keepend oneline concealends
    \ start='\*\*' end='\*\*' skip='\\\*\*'
    \ contains=HWSub,HWSup,HWInsert,HWDelete,HWItalic,HWHighlight,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   @CHWOthersInline
syn region HWItalicBold matchgroup=HWItalicBoldDelimiter keepend oneline concealends
    \ start='\*\*\*' end='\*\*\*' skip='\\\*\*\*'
    \ contains=HWSub,HWSup,HWInsert,HWDelete,HWItalic,HWHighlight,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   @CHWOthersInline
syn region HWHighlight matchgroup=HWHighlightDelimiter keepend oneline concealends
    \ start='[^=]\{-}\zs==' end='==\ze[^=]\{-}' skip='\\=='
    \ contains=HWSub,HWSup,HWInsert,HWDelete,HWItalic,HWBold,HWItalicBold,
    \   HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   @CHWOthersInline

syn cluster CHWTextDeclaration contains=HWSub,HWSup,HWInsert,HWDelete,HWItalic,HWBold,HWItalicBold,HWHighlight

"========================================\ Line /=======================================

"---------------------------------------\ lists /---------------------------------------
syn match HWList '^\s*\zs\(\d\+\.\|\d\+)\|-\|\*\|+\)\ze\s\+'
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   @CHWOthersInline

"--------------------------------------\ Heading /--------------------------------------
syn region HWHeading1 matchgroup=HWH1Delimiter start='^#\s\+'      end='$' keepend oneline
    \ contains=@CHWTextDeclaration
syn region HWHeading2 matchgroup=HWH2Delimiter start='^##\s\+'     end='$' keepend oneline
    \ contains=@CHWTextDeclaration
syn region HWHeading3 matchgroup=HWH3Delimiter start='^###\s\+'    end='$' keepend oneline
    \ contains=@CHWTextDeclaration
syn region HWHeading4 matchgroup=HWH4Delimiter start='^####\s\+'   end='$' keepend oneline
    \ contains=@CHWTextDeclaration
syn region HWHeading5 matchgroup=HWH5Delimiter start='^#####\s\+'  end='$' keepend oneline
    \ contains=@CHWTextDeclaration
syn region HWHeading6 matchgroup=HWH6Delimiter start='^######\s\+' end='$' keepend oneline
    \ contains=@CHWTextDeclaration

syn match  HWHeading2 '^.*$\n\ze-----*$' keepend
    \ contains=@CHWTextDeclaration

syn cluster CHWHeading contains=HWHeading1,HWHeading2,HWHeading3,HWHeading4,HWHeading5,HWHeading6

" if g:hexowiki_disable_fold == 0
"     syn match HWSection1 fold transparent
"         \ '^#\s\+\(.\|\n\)\{-}\ze\(^#\s\+\|\%$\)'
"         \ contains=HWHeading1,HWSection2,HWSection3,HWSection4,HWSection5,HWSection6
"     syn match HWSection2 fold transparent
"         \ '^##\s\+\(.\|\n\)\{-}\ze\(^#\{1,2}\s\+\|\%$\)'
"         \ contains=HWHeading2,HWSection3,HWSection4,HWSection5,HWSection6
"     syn match HWSection3 fold transparent
"         \ '^###\s\+\(.\|\n\)\{-}\ze\(^#\{1,3}\s\+\|\%$\)'
"         \ contains=HWHeading3,HWSection4,HWSection5,HWSection6
"     syn match HWSection4 fold transparent
"         \ '^####\s\+\(.\|\n\)\{-}\ze\(^#\{1,4}\s\+\|\%$\)'
"         \ contains=HWHeading4,HWSection5,HWSection6
"     syn match HWSection5 fold transparent
"         \ '^#####\s\+\(.\|\n\)\{-}\ze\(^#\{1,5}\s\+\|\%$\)'
"         \ contains=HWHeading5,HWSection6
"     syn match HWSection6 fold transparent
"         \ '^######\s\+\(.\|\n\)\{-}\ze\(^#\{1,6}\s\+\|\%$\)'
"         \ contains=ALLBUT,HWSection1,HWSection2,HWSection3,HWSection4,HWSection5,HWSection6
" endif

"=======================================\ Block /=======================================

"-------------------------------------\ Reference /-------------------------------------
syn region HWReference oneline
    \ start='^\s*>\s*' end='$'
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   HWReference,HWCodeBlock,HWMathBlock,HWList,@CHWTagBlock,
    \   HWReferenceHead,
    \   @CHWOthersInline
syn match  HWReferenceHead '^\s*>'hs=e contains=HWReferenceHead nextgroup=HWReference contains=HWReferenceHead contained conceal cchar=▊

"---------------------------------------\ Define /--------------------------------------
syn region HWDefine keepend fold transparent fold
    \ start='^[^:~\u0020\u0009].*\n\+\s*[:~]' end='\ze\n\{2,}[^:~\u0020\u0009]'
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,HWItalic,
    \   HWReference,HWCodeBlock,HWMathBlock,HWList,@CHWTagBlock,
    \   HWDefineHead,HWDefineContent,
    \   @CHWOthersInline
syn match HWDefineHead '^[^:~\u0020\u0009].*$' contained keepend
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag
syn region HWDefineContent matchgroup=HWDefineContentDelimiter contained keepend
    \ start='^\s*[:~]\s\+' end='\ze\n\s*[:~]\s\+'
    \ contains=HWEmoji,HWKeyword,@CHWLink,@CHWInlineCM,@CHWTextDeclaration,@CHWInlineTag,
    \   HWReference,HWCodeBlock,HWMathBlock,HWList,@CHWTagBlock,
    \   @CHWOthersInline

"+-------------------------------------------------------------------------------------+
"|                                    \ Highlight /                                    |
"+-------------------------------------------------------------------------------------+

"---------------------------------------\ Header /--------------------------------------
hi link HWHeader Define
hi link HWHeaderItem Keyword
hi link HWHeaderListDelimiter HWList

"------------------------------\ Original link or image /------------------------------
hi HWRawLink cterm=underline gui=underline
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
hi HWReference ctermfg=59 guifg=#5C6370
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

"----------------------------------------\ Abbr /---------------------------------------
hi HWAbbrHead cterm=bold,underline gui=bold,underline

"---------------------------------------\ Footer /--------------------------------------
hi HWFooter       cterm=bold,underline gui=bold,underline
hi HWFooterAnchor cterm=italic,underline gui=italic,underline

"----------------------------------\ Text declaration /---------------------------------
hi HWSub cterm=italic gui=italic
hi HWSup cterm=italic gui=italic
hi HWInsert cterm=underline gui=underline
hi HWDelete cterm=strikethrough gui=strikethrough
hi HWItalic cterm=italic gui=italic
hi HWBold cterm=bold gui=bold
hi HWItalicBold cterm=italic,bold gui=italic,bold
hi HWHighlight cterm=standout gui=standout

"---------------------------------------\ Define /--------------------------------------
hi HWDefineHead cterm=bold gui=bold
hi link HWDefineContent Comment

"---------------------------------------\ lists /---------------------------------------
hi HWList ctermfg=204 guifg=#E06C75

"------------------------------------\ Tags plugin /------------------------------------
hi HWTag cterm=italic,underline gui=italic,underline
hi link HWTagCodeBlock HWCodeBlock
hi link HWTagPostLink HWRawLink
" hi HWTagHideText ctermfg=145 ctermbg=145 guifg=#ABB2BF guibg=#ABB2BF

"--------------------------------------\ Keywords /-------------------------------------
hi link HWKeyword Keyword

"+-------------------------------------------------------------------------------------+
"|                                     \ Others /                                      |
"+-------------------------------------------------------------------------------------+
syn match HWHtmlBr '<br/\?>' conceal cchar=⤶      " ⤶↩↵
hi link HWHtmlBr Comment

hi link HWEscape Comment

syn cluster CHWOthersInline contains=HWHtmlBr,HWEscape,HWFooterAnchor

hi SpellBad gui=undercurl
