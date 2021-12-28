set -Ux EDITOR nvim
set -Ux VISUAL nvim
set -Ux HOME "/home/saravenpi"
set -Ux CODE "/home/saravenpi/Documents/code"
set -Ux SCHOOL "/home/saravenpi/Documents/code/epita"

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

alias q exit
alias hc "history clear"
alias c clear

alias nv nvim
alias office org.libreoffice.LibreOffice

# function to open my vim wiki with the current directory set to the vim wiki folder
function wk 
    set cur (pwd)
    cd "$HOME/vimwiki"
    nv index.wiki
    cd "$cur"
end

# function to open my neovim config with the current directory set to the neovim config folder
function nvc
    set cur (pwd)
    cd "$HOME/.config/nvim/"
    nv init.vim
    cd "$cur"
end

# function to open my fish config with the current directory set to the fish config folder
function fishc
    set cur (pwd)
    cd "$HOME/.config/fish/"
    nv config.fish
    cd "$cur"
end

alias h "cd $HOME"
alias goc "cd $CODE"
alias gos "cd $SCHOOL"
alias god "cd $CODE/dreamit"
alias goh "cd $CODE/honive"
alias gok "cd $CODE/kata"
alias goi "cd $SCHOOL/IP"

alias pdf evince
alias flex neofetch
alias todo "nv $HOME/Documents/TODO.md"

set fish_greeting "Hey, Sara, what are we doing today ?"
starship init fish | source
