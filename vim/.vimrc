let mapleader = " "
set tabstop=4
set shiftwidth=4
set expandtab
set number relativenumber
set smartindent

if v:version < 802
    packadd! dracula
endif
syntax enable
colorscheme dracula
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE

" File explorer shortcut
function! ToggleFileExplorer()
    let l:winNr = 1
    let l:found = 0
    while l:winNr <= winnr('$')
        if getbufvar(winbufnr(l:winNr), '&filetype') ==# 'netrw'
            let l:found = l:winNr
            break
        endif
        let l:winNr += 1
    endwhile

    if l:found
        exec l:found . 'wincmd c'
    else
        Sexplore
        wincmd H
        vertical resize 25
    endif
endfunction

" command! Sex call ToggleFileExplorer()

nnoremap <C-n> :call ToggleFileExplorer()<CR>

" Comment shortcut
function! CommentBlock()
    let l:filetype = &filetype
    let l:commentPrefix = ''

    if l:filetype == 'javascript' || l:filetype == 'java' || l:filetype == 'c' || l:filetype == 'cpp'
        let l:commentPrefix = '//'
    elseif l:filetype == 'python'
        let l:commentPrefix = '#'
    elseif l:filetype == 'vim'
        let l:commentPrefix = '"'
    else
        echo "Filetype not supported."
        return
    endif

    '<,'>s/^/\=l:commentPrefix . " "/
endfunction
xnoremap <Leader>c :call CommentBlock()<CR>
