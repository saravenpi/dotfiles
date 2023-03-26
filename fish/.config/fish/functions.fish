function o
    set cur (pwd)
    z $argv
    nvim
    cd $cur
end

function nvc
    set cur (pwd)
    cd "$HOME/.config/nvim/"
    nvim init.lua
    cd "$cur"
end

function fishc
    set cur (pwd)
    cd "$HOME/.config/fish/"
    nvim config.fish
    cd "$cur"
end

function kittyc
    set cur (pwd)
    cd "$HOME/.config/kitty/"
    nvim kitty.conf
    cd "$cur"
end

function i3c
    set cur (pwd)
    cd "$HOME/.config/i3/"
    nvim config
    cd "$cur"
end

function setp
    echo (pwd) > ~/.project
end

function gop
    cd (cat ~/.project)
end

function cinit
    kettle use c_project project &> /dev/null
    mv project/* .
    rm -rf project
    echo "Project Initialised ✅"
end

function wk 
    set cur (pwd)
    cd "$HOME/sarawiki/wiki/"
    nvim index.wiki
    cd "$cur"
end

function ob
    set cur (pwd)
    cd "$HOME/brain/"
    nvim .
    cd "$cur"
end

function a
    set file (fzf)
    nvim $file
end
