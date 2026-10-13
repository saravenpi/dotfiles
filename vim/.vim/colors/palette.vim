set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "palette"

hi Normal guifg=#e4e2e3 guibg=#111318 ctermfg=15 ctermbg=NONE
hi Comment guifg=#6b6d74 guibg=NONE ctermfg=8 ctermbg=NONE gui=italic cterm=italic
hi Constant guifg=#c2a95f guibg=NONE ctermfg=3 ctermbg=NONE
hi String guifg=#9db374 guibg=NONE ctermfg=2 ctermbg=NONE
hi Number guifg=#c2a95f guibg=NONE ctermfg=3 ctermbg=NONE
hi Boolean guifg=#c2a95f guibg=NONE ctermfg=3 ctermbg=NONE
hi Identifier guifg=#e4e2e3 guibg=NONE ctermfg=15 ctermbg=NONE
hi Function guifg=#82b1d4 guibg=NONE ctermfg=4 ctermbg=NONE
hi Statement guifg=#c49ed1 guibg=NONE ctermfg=5 ctermbg=NONE
hi Operator guifg=#72b6c0 guibg=NONE ctermfg=6 ctermbg=NONE
hi PreProc guifg=#72b6c0 guibg=NONE ctermfg=6 ctermbg=NONE
hi Type guifg=#c2a95f guibg=NONE ctermfg=3 ctermbg=NONE
hi Special guifg=#82b1d4 guibg=NONE ctermfg=4 ctermbg=NONE
hi Underlined guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=underline cterm=underline
hi Todo guifg=#c2a95f guibg=#111318 ctermfg=3 ctermbg=NONE gui=bold cterm=bold
hi Error guifg=#da98b5 guibg=#111318 ctermfg=1 ctermbg=NONE
hi WarningMsg guifg=#c2a95f guibg=NONE ctermfg=3 ctermbg=NONE
hi LineNr guifg=#6b6d74 guibg=NONE ctermfg=8 ctermbg=NONE
hi CursorLineNr guifg=#b4ccff guibg=NONE ctermfg=12 ctermbg=NONE gui=bold cterm=bold
hi CursorLine guifg=NONE guibg=#1d2025 ctermfg=NONE ctermbg=0
hi ColorColumn guifg=NONE guibg=#6b6d74 ctermfg=NONE ctermbg=8
hi Visual guifg=#111318 guibg=#b4ccff ctermfg=0 ctermbg=12
hi Search guifg=#111318 guibg=#c2a95f ctermfg=0 ctermbg=3
hi IncSearch guifg=#111318 guibg=#b4ccff ctermfg=0 ctermbg=12
hi Pmenu guifg=#e4e2e3 guibg=#1d2025 ctermfg=15 ctermbg=0
hi PmenuSel guifg=#111318 guibg=#b4ccff ctermfg=0 ctermbg=12
hi PmenuSbar guifg=NONE guibg=#1d2025 ctermfg=NONE ctermbg=0
hi PmenuThumb guifg=NONE guibg=#6b6d74 ctermfg=NONE ctermbg=8
hi StatusLine guifg=#e4e2e3 guibg=#1d2025 ctermfg=15 ctermbg=0
hi StatusLineNC guifg=#6b6d74 guibg=#111318 ctermfg=8 ctermbg=NONE
hi VertSplit guifg=#6b6d74 guibg=NONE ctermfg=8 ctermbg=NONE
hi TabLine guifg=#6b6d74 guibg=#111318 ctermfg=8 ctermbg=NONE gui=underline cterm=underline
hi TabLineSel guifg=#e4e2e3 guibg=#1d2025 ctermfg=15 ctermbg=0 gui=bold cterm=bold
hi TabLineFill guifg=NONE guibg=#111318 ctermfg=NONE ctermbg=NONE
hi Folded guifg=#6b6d74 guibg=#1d2025 ctermfg=8 ctermbg=0
hi SignColumn guifg=#6b6d74 guibg=#111318 ctermfg=8 ctermbg=NONE
hi Question guifg=#9db374 guibg=NONE ctermfg=2 ctermbg=NONE gui=bold cterm=bold
hi MoreMsg guifg=#9db374 guibg=NONE ctermfg=2 ctermbg=NONE
hi ModeMsg guifg=#e4e2e3 guibg=NONE ctermfg=15 ctermbg=NONE gui=bold cterm=bold
hi NonText guifg=#6b6d74 guibg=NONE ctermfg=8 ctermbg=NONE
hi SpecialKey guifg=#6b6d74 guibg=NONE ctermfg=8 ctermbg=NONE
hi Whitespace guifg=#6b6d74 guibg=NONE ctermfg=8 ctermbg=NONE
hi MatchParen guifg=#b4ccff guibg=NONE ctermfg=12 ctermbg=NONE gui=bold,underline cterm=bold,underline
hi DiffAdd guifg=#111318 guibg=#9db374 ctermfg=0 ctermbg=2
hi DiffChange guifg=#e4e2e3 guibg=#1d2025 ctermfg=15 ctermbg=0
hi DiffDelete guifg=#111318 guibg=#da98b5 ctermfg=0 ctermbg=1
hi DiffText guifg=#111318 guibg=#c2a95f ctermfg=0 ctermbg=3 gui=bold cterm=bold

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
