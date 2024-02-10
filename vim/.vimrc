function! ToggleFileExplorer()
    " Try to find an existing Netrw window by looking for 'NetrwTreeListing' in buffer names
    let l:winNr = 1
    let l:found = 0
    while l:winNr <= winnr('$')
        " Check if the buffer name contains 'NetrwTreeListing'
        if getbufvar(winbufnr(l:winNr), '&filetype') ==# 'netrw'
            let l:found = l:winNr
            break
        endif
        let l:winNr += 1
    endwhile

    " If found, close the Netrw window
    if l:found
        exec l:found . 'wincmd c'
    else
        " Open Netrw in a vertical split on the left side
        Sexplore
        " Move the explorer to the far left if not already
        wincmd H
        " Resize the window to make it narrower, 25 columns wide
        vertical resize 25
    endif
endfunction

" Optional: Create a custom command to toggle the explorer
command! Sex call ToggleFileExplorer()

" Bind the function to a shortcut, for example, <F2>
nnoremap <C-n> :call ToggleFileExplorer()<CR>

