set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -Ux HOME "/home/saravenpi"
set -Ux CODE "$HOME/code"
set -Ux SCHOOL "$HOME/school/"
set currentdate = (date)

alias ls "exa --icons"
alias ll "ls -lh"
alias la "ls -ah"
alias lal "ls -alh"
alias lla "ls -alh"
alias l ls
alias t "ls -T"
alias tl "ll -T"
alias tn "ls --tree --ignore-glob='node_modules'"
alias tnl "ll --ignore-glob='node_modules' -T"
alias tln "ll --ignore-glob='node_modules' -T"

alias rm "rm -i"

alias f fg
alias j jobs

alias neofetch "neofetch --backend kitty --source ~/Téléchargements/soviet_union_PNG46-1770112614.png"
alias q exit
alias hc "history clear"
alias c clear

alias ] "nvim ."
alias n nvim


function o
    set cur (pwd)
    z $argv
    nvim .
    cd $cur
end

# function to open my vim wiki with the current directory set to the vim wiki folder
function wk 
    set cur (pwd)
    cd "$HOME/sarawiki/wiki/"
    nvim index.wiki
    cd "$cur"
end

alias wkh "firefox $HOME/sarawiki/html/index.html"

# function to open my neovim config with the current directory set to the neovim config folder
function nvc
    set cur (pwd)
    cd "$HOME/.config/nvim/"
    nvim init.lua
    cd "$cur"
end

# function to open my fish config with the current directory set to the fish config folder
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


alias h "cd $HOME"
alias goc "cd $CODE"
alias gos "cd $SCHOOL"

alias gs "git status"
alias gp "git push"
alias ga "git add"
alias gc "git clone"
alias gd "git diff"
alias gr "git remove"

alias gitu "git add . && git commit && git push"
alias gituf "git add . && git commit -m \"$currentdate \"&& git push"

alias bb abricot
alias m make
alias mc "make clean"
alias mf "make fclean"
alias mfc "make fclean"
alias mr "make re"
alias mre mr
alias csc "sh /home/saravenpi/.coding-style.sh . . &> /dev/null; cat coding-style-reports.log; rm -f coding-style-reports.log"

alias :q exit
set fish_greeting ""
alias list-fonts "kitty +list-fonts --psnames"
starship init fish | source
