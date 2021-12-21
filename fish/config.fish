set -Ux EDITOR nvim
set -Ux VISUAL nvim
set HOME "/home/saravenpi"
set CODE "/home/saravenpi/Documents/code"
set SCHOOL "/home/saravenpi/Documents/code/epita"

alias ls "exa --icons"
alias ll "ls -l"
alias la "ls -a"
alias lal "ls -al"
alias l ls
alias tree "ls --tree"

alias rm "rm -i"

alias q exit
alias hc "history clear"
alias c clear

alias nv nvim

alias h "cd $HOME"
alias goc "cd $CODE"
alias gos "cd $SCHOOL"
alias god "cd $CODE/dreamit"
alias goh "cd $CODE/honive"
alias goi "cd $SCHOOL/IP"

alias pdf evince
alias flex neofetch
alias todo "nv $HOME/Documents/TODO.md"

set fish_greeting "Hey, Sara, what are we doing today ?"
starship init fish | source
