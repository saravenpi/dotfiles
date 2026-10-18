set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "palette"

hi Normal guifg=#e8e1dd guibg=#19120c ctermfg=15 ctermbg=NONE
hi Comment guifg=#776b5f guibg=NONE ctermfg=8 ctermbg=NONE gui=italic cterm=italic
hi Constant guifg=#d6a163 guibg=NONE ctermfg=3 ctermbg=NONE
hi String guifg=#a2b275 guibg=NONE ctermfg=2 ctermbg=NONE
hi Number guifg=#d6a163 guibg=NONE ctermfg=3 ctermbg=NONE
hi Boolean guifg=#d6a163 guibg=NONE ctermfg=3 ctermbg=NONE
hi Identifier guifg=#e8e1dd guibg=NONE ctermfg=15 ctermbg=NONE
hi Function guifg=#5eb5e1 guibg=NONE ctermfg=4 ctermbg=NONE
hi Statement guifg=#ca9dc7 guibg=NONE ctermfg=5 ctermbg=NONE
hi Operator guifg=#79b7a8 guibg=NONE ctermfg=6 ctermbg=NONE
hi PreProc guifg=#79b7a8 guibg=NONE ctermfg=6 ctermbg=NONE
hi Type guifg=#d6a163 guibg=NONE ctermfg=3 ctermbg=NONE
hi Special guifg=#5eb5e1 guibg=NONE ctermfg=4 ctermbg=NONE
hi Underlined guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=underline cterm=underline
hi Todo guifg=#d6a163 guibg=#19120c ctermfg=3 ctermbg=NONE gui=bold cterm=bold
hi Error guifg=#ff8a70 guibg=#19120c ctermfg=1 ctermbg=NONE
hi WarningMsg guifg=#d6a163 guibg=NONE ctermfg=3 ctermbg=NONE
hi LineNr guifg=#776b5f guibg=NONE ctermfg=8 ctermbg=NONE
hi CursorLineNr guifg=#ffc079 guibg=NONE ctermfg=11 ctermbg=NONE gui=bold cterm=bold
hi CursorLine guifg=NONE guibg=#261e15 ctermfg=NONE ctermbg=0
hi ColorColumn guifg=NONE guibg=#776b5f ctermfg=NONE ctermbg=8
hi Visual guifg=#19120c guibg=#ffc079 ctermfg=0 ctermbg=11
hi Search guifg=#19120c guibg=#d6a163 ctermfg=0 ctermbg=3
hi IncSearch guifg=#19120c guibg=#ffc079 ctermfg=0 ctermbg=11
hi Pmenu guifg=#e8e1dd guibg=#261e15 ctermfg=15 ctermbg=0
hi PmenuSel guifg=#19120c guibg=#ffc079 ctermfg=0 ctermbg=11
hi PmenuSbar guifg=NONE guibg=#261e15 ctermfg=NONE ctermbg=0
hi PmenuThumb guifg=NONE guibg=#776b5f ctermfg=NONE ctermbg=8
hi StatusLine guifg=#e8e1dd guibg=#261e15 ctermfg=15 ctermbg=0
hi StatusLineNC guifg=#776b5f guibg=#19120c ctermfg=8 ctermbg=NONE
hi VertSplit guifg=#776b5f guibg=NONE ctermfg=8 ctermbg=NONE
hi TabLine guifg=#776b5f guibg=#19120c ctermfg=8 ctermbg=NONE gui=underline cterm=underline
hi TabLineSel guifg=#e8e1dd guibg=#261e15 ctermfg=15 ctermbg=0 gui=bold cterm=bold
hi TabLineFill guifg=NONE guibg=#19120c ctermfg=NONE ctermbg=NONE
hi Folded guifg=#776b5f guibg=#261e15 ctermfg=8 ctermbg=0
hi SignColumn guifg=#776b5f guibg=#19120c ctermfg=8 ctermbg=NONE
hi Question guifg=#a2b275 guibg=NONE ctermfg=2 ctermbg=NONE gui=bold cterm=bold
hi MoreMsg guifg=#a2b275 guibg=NONE ctermfg=2 ctermbg=NONE
hi ModeMsg guifg=#e8e1dd guibg=NONE ctermfg=15 ctermbg=NONE gui=bold cterm=bold
hi NonText guifg=#776b5f guibg=NONE ctermfg=8 ctermbg=NONE
hi SpecialKey guifg=#776b5f guibg=NONE ctermfg=8 ctermbg=NONE
hi Whitespace guifg=#776b5f guibg=NONE ctermfg=8 ctermbg=NONE
hi MatchParen guifg=#ffc079 guibg=NONE ctermfg=11 ctermbg=NONE gui=bold,underline cterm=bold,underline
hi DiffAdd guifg=#19120c guibg=#a2b275 ctermfg=0 ctermbg=2
hi DiffChange guifg=#e8e1dd guibg=#261e15 ctermfg=15 ctermbg=0
hi DiffDelete guifg=#19120c guibg=#ff8a70 ctermfg=0 ctermbg=1
hi DiffText guifg=#19120c guibg=#d6a163 ctermfg=0 ctermbg=3 gui=bold cterm=bold

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
