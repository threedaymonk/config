" A 256-colour terminal version of ir_black
" Based on http://blog.toddwerth.com/entries/8
" Paul Battley - http://po-ru.com

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "subzero"

" General colors
hi Normal        ctermfg=none   ctermbg=none
hi NonText       ctermfg=232    ctermbg=none

hi Cursor        ctermfg=none   ctermbg=white
hi LineNr        ctermfg=237    ctermbg=none

hi VertSplit     ctermfg=234    ctermbg=234
hi StatusLine    ctermfg=250    ctermbg=234
hi StatusLineNC  ctermfg=none   ctermbg=234

hi Folded        ctermfg=none   ctermbg=none
hi Title         ctermfg=136    ctermbg=none    cterm=bold
hi Visual        ctermfg=none   ctermbg=23

hi SpecialKey    ctermfg=8      ctermbg=236

hi WildMenu      ctermfg=green  ctermbg=yellow
hi PmenuSbar     ctermfg=none   ctermbg=white

hi Error         ctermfg=none   ctermbg=none    cterm=underline
hi ErrorMsg      ctermfg=white  ctermbg=203     cterm=bold
hi WarningMsg    ctermfg=white  ctermbg=203     cterm=bold

" Message displayed in lower left, such as --INSERT--
hi ModeMsg       ctermfg=yellow   ctermbg=none     cterm=bold

" Right-hand margin indicator
highlight ColorColumn ctermbg=234

if version >= 700 " Vim 7.x specific colors
  hi CursorLine    ctermfg=none  ctermbg=233
  hi CursorColumn  ctermfg=none  ctermbg=233
  hi MatchParen    ctermfg=232   ctermbg=166   cterm=bold
  hi Pmenu         ctermfg=136   ctermbg=238
  hi PmenuSel      ctermfg=0     ctermbg=64
  hi Search        ctermfg=none  ctermbg=none  cterm=underline
endif

" Syntax highlighting
hi Comment      ctermfg=243    ctermbg=none
hi String       ctermfg=46     ctermbg=none
hi Number       ctermfg=13     ctermbg=none

hi Keyword      ctermfg=153    ctermbg=none
hi PreProc      ctermfg=153    ctermbg=none
hi Conditional  ctermfg=110    ctermbg=none  " if else end

hi Todo         ctermfg=245    ctermbg=none
hi Constant     ctermfg=141    ctermbg=none

hi Identifier   ctermfg=189    ctermbg=none
hi Function     ctermfg=215    ctermbg=none
hi Type         ctermfg=229    ctermbg=none
hi Statement    ctermfg=110    ctermbg=none

hi Special      ctermfg=173    ctermbg=none
hi Delimiter    ctermfg=37     ctermbg=none
hi Operator     ctermfg=white  ctermbg=none

hi link Character       Constant
hi link Boolean         Constant
hi link Float           Number
hi link Repeat          Statement
hi link Label           Statement
hi link Exception       Statement
hi link Include         PreProc
hi link Define          PreProc
hi link Macro           PreProc
hi link PreCondit       PreProc
hi link StorageClass    Type
hi link Structure       Type
hi link Typedef         Type
hi link Tag             Special
hi link SpecialChar     Special
hi link SpecialComment  Special
hi link Debug           Special


" Ruby
hi rubyRegexp                  ctermfg=208    ctermbg=none
hi rubyRegexpDelimiter         ctermfg=130    ctermbg=none
hi rubyRegexpSpecial           ctermfg=white  ctermbg=none
hi rubyEscape                  ctermfg=white  ctermbg=none
hi rubyInterpolationDelimiter  ctermfg=37     ctermbg=none
hi rubyControl                 ctermfg=110    ctermbg=none  "and break, etc
hi rubyStringDelimiter         ctermfg=65     ctermbg=none

hi link rubyClass             Keyword
hi link rubyModule            Keyword
hi link rubyKeyword           Keyword
hi link rubyOperator          Operator
hi link rubyIdentifier        Identifier
hi link rubyInstanceVariable  Identifier
hi link rubyGlobalVariable    Identifier
hi link rubyClassVariable     Identifier
hi link rubyConstant          Type


" Java
hi link javaScopeDecl         Identifier
hi link javaCommentTitle      javaDocSeeTag
hi link javaDocTags           javaDocSeeTag
hi link javaDocParam          javaDocSeeTag
hi link javaDocSeeTagParam    javaDocSeeTag

hi javaDocSeeTag              ctermfg=250     ctermbg=none
hi javaDocSeeTag              ctermfg=250     ctermbg=none


" XML
hi link xmlTag          Keyword
hi link xmlTagName      Conditional
hi link xmlEndTag       Identifier


" HTML
hi link htmlTag         Keyword
hi link htmlTagName     Conditional
hi link htmlEndTag      Identifier


" Javascript
hi link javaScriptNumber      Number

" C#
hi  link csXmlTag             Keyword

" Rainbow parens
hi level1c ctermfg=magenta
hi level2c ctermfg=red
hi level3c ctermfg=208
hi level4c ctermfg=yellow
hi level5c ctermfg=green

" MatchTagAlways
highlight MatchTag ctermfg=black ctermbg=153

" Clear the gutter
highlight clear SignColumn

" Tabs and trailing spaces
hi def Tab ctermbg=red
hi def TrailingWS ctermbg=red
