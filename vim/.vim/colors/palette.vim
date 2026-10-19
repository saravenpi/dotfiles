set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "palette"

hi Normal guifg=#e5e2dd guibg=#13140b ctermfg=15 ctermbg=NONE
hi Comment guifg=#6c6e5f guibg=NONE ctermfg=8 ctermbg=NONE gui=italic cterm=italic
hi Constant guifg=#baab67 guibg=NONE ctermfg=3 ctermbg=NONE
hi String guifg=#a4b26f guibg=NONE ctermfg=2 ctermbg=NONE
hi Number guifg=#baab67 guibg=NONE ctermfg=3 ctermbg=NONE
hi Boolean guifg=#baab67 guibg=NONE ctermfg=3 ctermbg=NONE
hi Identifier guifg=#e5e2dd guibg=NONE ctermfg=15 ctermbg=NONE
hi Function guifg=#81b1ce guibg=NONE ctermfg=4 ctermbg=NONE
hi Statement guifg=#ca9dc7 guibg=NONE ctermfg=5 ctermbg=NONE
hi Operator guifg=#79b7a8 guibg=NONE ctermfg=6 ctermbg=NONE
hi PreProc guifg=#79b7a8 guibg=NONE ctermfg=6 ctermbg=NONE
hi Type guifg=#baab67 guibg=NONE ctermfg=3 ctermbg=NONE
hi Special guifg=#81b1ce guibg=NONE ctermfg=4 ctermbg=NONE
hi Underlined guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=underline cterm=underline
hi Todo guifg=#baab67 guibg=#13140b ctermfg=3 ctermbg=NONE gui=bold cterm=bold
hi Error guifg=#e09b7f guibg=#13140b ctermfg=1 ctermbg=NONE
hi WarningMsg guifg=#baab67 guibg=NONE ctermfg=3 ctermbg=NONE
hi LineNr guifg=#6c6e5f guibg=NONE ctermfg=8 ctermbg=NONE
hi CursorLineNr guifg=#c3d486 guibg=NONE ctermfg=10 ctermbg=NONE gui=bold cterm=bold
hi CursorLine guifg=NONE guibg=#1e2115 ctermfg=NONE ctermbg=0
hi ColorColumn guifg=NONE guibg=#6c6e5f ctermfg=NONE ctermbg=8
hi Visual guifg=#13140b guibg=#c3d486 ctermfg=0 ctermbg=10
hi Search guifg=#13140b guibg=#baab67 ctermfg=0 ctermbg=3
hi IncSearch guifg=#13140b guibg=#c3d486 ctermfg=0 ctermbg=10
hi Pmenu guifg=#e5e2dd guibg=#1e2115 ctermfg=15 ctermbg=0
hi PmenuSel guifg=#13140b guibg=#c3d486 ctermfg=0 ctermbg=10
hi PmenuSbar guifg=NONE guibg=#1e2115 ctermfg=NONE ctermbg=0
hi PmenuThumb guifg=NONE guibg=#6c6e5f ctermfg=NONE ctermbg=8
hi StatusLine guifg=#e5e2dd guibg=#1e2115 ctermfg=15 ctermbg=0
hi StatusLineNC guifg=#6c6e5f guibg=#13140b ctermfg=8 ctermbg=NONE
hi VertSplit guifg=#6c6e5f guibg=NONE ctermfg=8 ctermbg=NONE
hi TabLine guifg=#6c6e5f guibg=#13140b ctermfg=8 ctermbg=NONE gui=underline cterm=underline
hi TabLineSel guifg=#e5e2dd guibg=#1e2115 ctermfg=15 ctermbg=0 gui=bold cterm=bold
hi TabLineFill guifg=NONE guibg=#13140b ctermfg=NONE ctermbg=NONE
hi Folded guifg=#6c6e5f guibg=#1e2115 ctermfg=8 ctermbg=0
hi SignColumn guifg=#6c6e5f guibg=#13140b ctermfg=8 ctermbg=NONE
hi Question guifg=#a4b26f guibg=NONE ctermfg=2 ctermbg=NONE gui=bold cterm=bold
hi MoreMsg guifg=#a4b26f guibg=NONE ctermfg=2 ctermbg=NONE
hi ModeMsg guifg=#e5e2dd guibg=NONE ctermfg=15 ctermbg=NONE gui=bold cterm=bold
hi NonText guifg=#6c6e5f guibg=NONE ctermfg=8 ctermbg=NONE
hi SpecialKey guifg=#6c6e5f guibg=NONE ctermfg=8 ctermbg=NONE
hi Whitespace guifg=#6c6e5f guibg=NONE ctermfg=8 ctermbg=NONE
hi MatchParen guifg=#c3d486 guibg=NONE ctermfg=10 ctermbg=NONE gui=bold,underline cterm=bold,underline
hi DiffAdd guifg=#13140b guibg=#a4b26f ctermfg=0 ctermbg=2
hi DiffChange guifg=#e5e2dd guibg=#1e2115 ctermfg=15 ctermbg=0
hi DiffDelete guifg=#13140b guibg=#e09b7f ctermfg=0 ctermbg=1
hi DiffText guifg=#13140b guibg=#baab67 ctermfg=0 ctermbg=3 gui=bold cterm=bold

hi! link Character String
hi! link Float Number
hi! link Conditional Statement
hi! link Repeat Statement
hi! link Label Statement
hi! link Keyword Statement
hi! link Exception Statement
hi! link Include PreProc
hi! link Define PreProc
hi! link Macro PreProc
hi! link PreCondit PreProc
hi! link StorageClass Type
hi! link Structure Type
hi! link Typedef Type
hi! link SpecialChar Special
hi! link Tag Special
hi! link Delimiter Special
hi! link SpecialComment Comment
hi! link CursorColumn CursorLine
hi! link FoldColumn SignColumn
hi! link WildMenu PmenuSel
