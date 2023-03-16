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

alias z zoxide
alias q exit
alias hc "history clear"
alias c clear

alias ] "nvim"
alias n nvim
alias nv nvim

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
alias csc "sh $HOME/.coding-style.sh . . &> /dev/null; cat coding-style-reports.log; rm -f coding-style-reports.log"

alias :q exit

alias i3bye "i3-msg exit"

alias list-fonts "kitty +list-fonts --psnames"
