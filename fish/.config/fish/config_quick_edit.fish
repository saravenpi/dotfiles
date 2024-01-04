for file in (exa ~/dotfiles/)
    set als "c$file"
    abbr $als "set cur (pwd) ; cd ~/dotfiles/$file/.config/$file ; nvim . ; cd $cur"
end
